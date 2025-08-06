# frozen_string_literal: true

class TagsController < ApplicationController
  get "/tags" do
    tags = Tag.all
    tags.to_json(include: :cards)
  end

  get "/tags/:id" do
    tag = Tag.find(params[:id])
    tag.to_json(include: :cards)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Tag not found" }.to_json
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

  get "/tags/:id/cards" do
    tag = Tag.find(params[:id])
    cards = tag.cards
    cards.to_json(include: %i[tag tags])
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Tag not found" }.to_json
  end
end
