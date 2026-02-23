class TweetsController < ApplicationController
  def new
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.shortened = RubyLLM.chat.with_temperature(1.2).ask("Generate an unhinged tweet from this text: #{@tweet.long}").content
    if @tweet.save
      redirect_to tweet_path(@tweet), notice: "Tweet successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:long)
  end
end
