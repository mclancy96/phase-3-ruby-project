# frozen_string_literal: true

class CardsController < ApplicationController
  get "/cards/:id" do
    card = Card.find(params[:id])
    card.to_json(include: :tags)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Card not found" }.to_json
  end

  post "/cards" do
    card = Card.create(
      front: params[:front],
      back: params[:back],
      deck_id: params[:deck_id]
    )

    if card.persisted?
      status 201
      card.to_json(include: :tags)
    else
      status 422
      { errors: card.errors.full_messages }.to_json
    end
  end

  patch "/cards/:id" do
    card = Card.find(params[:id])

    if card.update(
      front: params[:front],
      back: params[:back],
      deck_id: params[:deck_id]
    )
      card.to_json
    else
      status 422
      { errors: card.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Card not found" }.to_json
  end

  delete "/cards/:id" do
    card = Card.find(params[:id])
    card.destroy
    status 204
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Card not found" }.to_json
  end

  get "/cards/:id/tags" do
    card = Card.find(params[:id])
    cards = card.cards
    cards.to_json(include: :card)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Card not found" }.to_json
  end
end
