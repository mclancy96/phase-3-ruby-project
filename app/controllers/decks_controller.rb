# frozen_string_literal: true

class DecksController < ApplicationController
  get "/decks" do
    decks = Deck.all
    decks.to_json(include: :cards)
  end

  get "/decks/:id" do
    deck = Deck.find(params[:id])
    deck.to_json(include: :cards)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Deck not found" }.to_json
  end

  post "/decks" do
    deck = Deck.create(
      name: params[:name],
      description: params[:description]
    )

    if deck.persisted?
      status 201
      deck.to_json
    else
      status 422
      { errors: deck.errors.full_messages }.to_json
    end
  end

  patch "/decks/:id" do
    deck = Deck.find(params[:id])

    if deck.update(
      name: params[:name],
      description: params[:description]
    )
      deck.to_json
    else
      status 422
      { errors: deck.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Deck not found" }.to_json
  end

  delete "/decks/:id" do
    deck = Deck.find(params[:id])
    deck.destroy
    status 204
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Deck not found" }.to_json
  end

  get "/decks/:id/cards" do
    deck = Deck.find(params[:id])
    cards = deck.cards
    cards.to_json(include: :deck)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Deck not found" }.to_json
  end
end
