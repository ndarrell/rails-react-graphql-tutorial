Types::YetiType = GraphQL::ObjectType.define do
  name "Yeti"
  description 'A Yeti that shares all of its personal information.'

  # `!` marks a field as "non-null"
  field :id, !types.ID
  field :name, !types.String
  field :email, types.String
end
