class TagsController < ApplicationController
  get "/tags" do
    if params[:name]
      tags = Tag.where("tags.name = ?", params[:name]).order(name: :asc)
      tags.to_json
    else
      tags = Tag.order(name: :asc)
      tags.to_json(include: :cards)
    end
  end

  post "/tags" do
    tag = Tag.create(
      name: params[:name]
    )

    if tag.persisted?
      status 201
      tag.to_json
    else
      status 422
      { errors: tag.errors.full_messages }.to_json
    end
  end

  patch "/tags/:id" do
    tag = Tag.find(params[:id])

    if tag.update(
      name: params[:name]
    )
      tag.to_json
    else
      status 422
      { errors: tag.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Tag not found" }.to_json
  end

  delete "/tags/:id" do
    tag = Tag.find(params[:id])
    tag.destroy
    status 204
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Tag not found" }.to_json
  rescue ActiveRecord::InvalidForeignKey
    status 422
    { error: "Cannot delete tag: tag contains cards that must be removed first" }.to_json
  end
end
