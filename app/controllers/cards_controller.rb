# frozen_string_literal: true

class CardsController < ApplicationController
  get "/cards/:id" do
    card = Card.find(params[:id])
    card.to_json(include: :cards)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Card not found" }.to_json
  end

  post "/cards" do
    card = Card.create(
      name: params[:name],
      description: params[:description]
    )

    if card.persisted?
      status 201
      card.to_json
    else
      status 422
      { errors: card.errors.full_messages }.to_json
    end
  end

  patch "/cards/:id" do
    card = Card.find(params[:id])

    if card.update(
      name: params[:name],
      description: params[:description]
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
