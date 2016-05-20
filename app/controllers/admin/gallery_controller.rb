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
      image = GalleryImage.create(tags: params[:tags])
      image.tags[:all] = true
      image.attach(:file, file)
      image.save
    end

    render json: {}
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
