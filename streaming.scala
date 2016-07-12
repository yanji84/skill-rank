package org.apache.spark.examples.streaming

import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.SparkContext._
import org.apache.spark.streaming.twitter._
import org.apache.spark.SparkConf
import org.apache.spark.streaming.StreamingContext._

object Twitter {
  def main(args: Array[String]) {

    // set up twitter account
    System.setProperty("twitter4j.oauth.consumerKey", "EBCKtNuL2sXEyqelVwHpDA")
    System.setProperty("twitter4j.oauth.consumerSecret", "K9ayEuxwNPQf9hJLqqLxaOutmfOMFqsGKnoO9DsFRtA")
    System.setProperty("twitter4j.oauth.accessToken", "19001933-OZaxJudSqXlOS6Jsa1C4RvgGOsqGgUNCaqC8sKCqY")
    System.setProperty("twitter4j.oauth.accessTokenSecret", "yTwvgfHyKVBJtyz8o06mHx0NXnJgqjIBIq930yuA8")

    // read main params
    val intervalInSec = args(0).toInt
    val topTopicCount = args(1).toInt

    // set up spark context and prepare source stream
    val sparkConf = new SparkConf().setAppName("Twitter")
    val ssc = new StreamingContext(sparkConf, Seconds(1))
    val tweets = TwitterUtils.createStream(ssc, None)

    // apply custom interval on original one second batch D-stream with one second slide duration
    val tweetsByInterval = tweets.window(Seconds(intervalInSec), Seconds(1))

    // break each tweet down to a mapping from hashtag to original tweet
    val hashtagMap = tweetsByInterval.flatMap(tweet => tweet.getText().split(" ").filter(w => w.startsWith("#")).map(w => (w, tweet)))

    // collect count for each hashtag
    val hashtagCount = hashtagMap.map(tag => (tag._1, (1,tag._2))).reduceByKey((a,b) => (a._1 + b._1, a._2))

    // sort tweets based on hashtag count
    val sortedHashTagCount = hashtagCount.map {
        case(tag, v) => (v._1,
                         if (v._2.getUserMentionEntities().length == 0)
                            "the hashtag %s in %s appeared %d times. it is tweeted by %s and has no mention".format(tag,
                                                                                                                    v._2.getText(),
                                                                                                                    v._1,
                                                                                                                    v._2.getUser().getName())
                         else
                            "the hashtag %s in %s appeared %d times. it is tweeted by %s and has mentioned %s".format(tag,
                                                                                                                      v._2.getText(),
                                                                                                                      v._1,
                                                                                                                      v._2.getUser().getName(),
                                                                                                                      v._2.getUserMentionEntities().map(e => e.getName()).mkString(",")))
    }.transform(rdd => rdd.sortByKey(false))

    // take most popular hashtags with respective tweets, mentions, author...
    sortedHashTagCount.foreach(rdd => println("\nFor current time window: \n" + rdd.take(topTopicCount).map(t => t._2).mkString("\n")))

    ssc.start()
    ssc.awaitTermination()
  }
}