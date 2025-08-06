class CardTagsController < ApplicationController
  post "/card_tags" do
    card_tag = CardTag.create(
      card_id: params[:card_id],
      tag_id: params[:tag_id]
    )

    if card_tag.persisted?
      status 201
      card_tag.to_json(include: :tag)
    else
      status 422
      { errors: card_tag.errors.full_messages }.to_json
    end
  end

  delete "/card_tags" do
    card_tag = CardTag.find_by(card_id: params[:card_id], tag_id: params[:tag_id])
    if card_tag
      card_tag.destroy
      status 204
    else
      status 404
      { error: "CardTag association not found" }.to_json
    end
  end
end
