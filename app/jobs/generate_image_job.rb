class GenerateImageJob < ApplicationJob
  queue_as :default
  include ActionView::RecordIdentifier

  def perform(tweet)
    # Do something later
    # puts "Use ruby llm paint method to generate an image"
    # sleep(3)
    # puts "Job done"
    @tweet = tweet
    @image = RubyLLM.paint("Generate an image based on this text: #{@tweet.shortened}. Do not put text into the image.") unless @tweet.photo.attached?
    io = StringIO.new(@image.to_blob)
    filename = "tweet-#{Time.now.to_i}.png"
    @tweet.photo.attach(
      io: io,
      filename: filename,
      content_type: "image/png"
    )
    # stream image to the tweet show
    Turbo::StreamsChannel.broadcast_replace_to(
      @tweet, # name of the stream
      target: dom_id(@tweet), # the div id we set in the partial
      partial: "tweets/photo",
      locals: { tweet: @tweet }
    )
  end
end
