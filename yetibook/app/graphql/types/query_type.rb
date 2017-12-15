Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  description 'The query root for this schema.'
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :yeti  do
    type types[Types::YetiType]
    description 'Get info on yetis.'

    argument :name, types.String, 'Get info on yeti with name, if given. Otherwise, get info for every yeti.'

    resolve -> (obj, args, ctx) do
      p Yeti.all.to_a
      args[:name] ? [] << Yeti.find_by(name: args[:name]) : Yeti.all.to_a
    end
  end

end
