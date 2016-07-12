import subprocess
import datetime
import os

# path on HDFS that stores upload progress
progressPath = '/251/data/import_progress.txt'

# base path on HDFS that stores uploaded data
basePath = '/251/data'

# specifies how often to update upload progress in hours
updateProgressCadenceInHours = 24

def readLatestProgress():
	p = subprocess.Popen(['hadoop', 'fs', '-cat', progressPath], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	out, err = p.communicate()
	d = datetime.datetime.strptime(out.split('\n')[0], '%Y-%m-%d')
	return d

def download(url):
	# -N means not retrieve new file unless newer than local
	r = os.system("wget -N %s -P /tmp/" % url)
	if r == 0:
		return "/tmp/" + url.split("/")[-1]
	else:
		return None

def copyToHDFS(f):
	splits = f.split("/")[-1].split(".")[0].split("-")
	year = splits[0]
	month = splits[1]
	day = splits[2]
	p = '/'.join([basePath, year, month, day])

	# first create hadoop directory
	r = os.system("hadoop fs -mkdir -p %s" % p)
	raiseIfNecessary(r, 'Failed to create HDFS directory...')
	r = os.system("hadoop fs -copyFromLocal -f %s %s" % (f, p))
	raiseIfNecessary(r, 'Failed to upload to HDFS...')

def upload(hourToUpload):
	fmt = "%Y-%m-%d-%-H"
	url = 'http://data.githubarchive.org/' + hourToUpload.strftime(fmt) + '.json.gz'
	f = download(url)
	if f is not None:
		copyToHDFS(f)
		return True
	else:
		return None

def updateProgress(d):
	fmt = "%Y-%m-%d"
	progress = d.strftime(fmt)
	r = os.system("echo %s > /tmp/progress.out" % progress)
	raiseIfNecessary(r, 'Failed to save progress locally...')
	r = os.system("hadoop fs -copyFromLocal -f /tmp/progress.out %s" % progressPath)
	raiseIfNecessary(r, 'Failed to update progress to HDFS...')

def raiseIfNecessary(r, m):
	if r != 0:
		raise Exception(m)

def main():
	counter = 0
	start = readLatestProgress()
	end = datetime.datetime.now()
	hour = datetime.timedelta(hours=1)
	while start <= end:
		r = upload(start)
		print ("Finished uploading %s..." % start)

		# update progress if upload is successful
		if r is not None:
			counter += 1
			if counter % updateProgressCadenceInHours == 0:
				updateProgress(start)
				print ("Updated progress to %s..." % start)

		start += hour

main()