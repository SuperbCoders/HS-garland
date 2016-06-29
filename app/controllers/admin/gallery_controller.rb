class Admin::GalleryController < ApplicationController

  def destroy
    result = {success: false, error: ''}
    image = GalleryImage.find(params[:id])
    if image and image.destroy
      result[:success] = true
    else
      result[:error] = image.errors.full_messages.first
    end

    render json: result
  end

  def upload
    params[:files].each do |file|
      image = GalleryImage.create(tags: params[:tags], description: file[:description])
      image.tags[:all] = true
      image.attach(:file, file)
      image.date = image_date(file[:date])
      image.save
    end

    render json: {}
  end

  def image_date(date_str)
    "#{date_str[0..1]}.#{date_str[2..3]}.#{date_str[4..8]}".to_date
  end

  def slider_destroy
    result = {success: false, error: ''}
    image = SliderImage.find(params[:id])
    if image and image.destroy
      result[:success] = true
    else
      result[:error] = image.errors.full_messages.first
    end

    render json: result
  end

  def slider_upload
    params[:files].each do |file|
      image = SliderImage.create
      image.attach(:file, file)
    end

    render json: {}
  end

  def slider_index
    render json: serialize_resources(SliderImage.all, Admin::SliderImageSerializer)
  end

  def index
    render json: serialize_resources(GalleryImage.all, Admin::GalleryImageSerializer)
  end
end
