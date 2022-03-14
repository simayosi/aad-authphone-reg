# frozen_string_literal: true

# Migration class
class CreateCachedTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :cached_tokens, id: false do |t|
      t.primary_key :id, :string, charset: :ascii
      t.datetime :expire
      t.string :type
      t.text :value
      t.text :scope
    end
  end
end
