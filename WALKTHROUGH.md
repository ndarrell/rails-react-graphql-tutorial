# Walkthrough
This is meant to give you an understanding of Rails, React, and GraphQL by
building a project from the ground up. Given variations in understanding between developers, this guide assumes you know nothing about anything. Feel free to skip what you already know about.

## Table of Contents
1. [Setting Our Foundation](#setting-our-foundation)
2. [Building the Backend](#building-the-backend)

## Setting Our Foundation
You will need some basic tools to get started. The starting blocks are [Ruby][Ruby], [RubyGems][RubyGems], and [Rails][Rails].

### Ruby

`Ruby` is the language that `Rails` and the rest of our backend logic is written in. If
you are using macOS, Ruby should already be installed. Verify this by doing

```bash
$ ruby --version
```

If you'd like, you can also use `rvm` to update to a later version.

### Rubygems
Rubygems should already be installed if you have a version of Ruby > 1.9.1

You can verify you have it by doing

```bash
$ gem --version
```

### Rails
Now that you have both Ruby and Rubygems, all you have to do to get Rails is
```bash
$ gem install rails
```

You can make sure it's available by doing `rails --version`.

### Homebrew
_This only applies to macOS users!_

Go [here][Homebrew] for instructions on how to install `Homebrew` (a package manager for macOS).

Using Homebrew, install `nodeJS/npm`, `yarn`, and `PostgreSQL`.

Once you install the latest `nodeJS`, it should come with `npm`, but, `yetibook` will use `yarn` instead.
```bash
$ brew install node
$ brew install yarn
```

`PostgreSQL` is an open-source, object-relational database.
```bash
$ brew install postgresql
```

## Building the Backend

### Generating a new project
Our project will be a Facebook for Yetis, aptly named Yetibook.

Generate a new project in your current directory by doing

```bash
$ rails new yetibook -d postgresql --webpack=react
```

What this command does is:

1. Create a `new` project with `Rails` in our current directory called
`yetibook`.
2. Specify that the database that `yetibook` will use will be `PostgreSQL`.
3. Tells `Webpacker` that we want to use `React`.

`rails -h` and `rails [command] -h` can give you more information.

At this point, the project should be functional. Try to run
```bash
$ rails server
```

or

```bash
$ rails s
```

### Generating an MVC
Rails gives plenty of options to generate things to speed up development. `cd` into your rails project and then do
```bash
$ rails generate --help
```
to see what options you have at your disposal.

Rails has an alias for `generate`, so you can do

```bash
$ rails g --help
```

if you enjoy brevity.

To see all of the shortcuts try `rails --help`.

#### Model
Let's finally generate some components:
```bash
$ rails g model yeti name:string email:string:uniq password:digest
```

We just
1. Created a new `model` for Yetis (aka, users of our application).
2. Told `rails` that each `yeti` has a name, unique email, and a password

#### Controller/View
```bash
$ rails generate controller yetis create
```
1. This will create a controller called `YetisController` which will be responsible for handling changes to our `yeti` model.
2. Make an action called `new`; this is a `GET` request for the signup page.
2. Make an action called `create`; this will be a `POST` that occurs whenever a new yeti joins Yetibook.
2. Make an action called `index`; a `GET` for every yeti.
3. This also creates a view for users of our application to get to add themselves to Yetibook.
4. Add a test file for this controller.

You should explore the files that this has created in the `app` and `test` directories.

### Running tests
```bash
$ rails test
```
or
```bash
$ rails t
```
_Oops!_ Looks like we got an error when we did that.

```bash
$ pg-0.21.0/lib/pg.rb:56:in \`initialize\': could not connect to server: No
such file or directory (PG::ConnectionBad)
```
All this means is that we need to start the PostgreSQL database.

```bash
$ pg_ctl init -D path/to/db/files
$ pg_ctl -D path/to/db/files -l logfile start
```

We're still not done. We need to create test and development databases. It would probably be easier to use `SQLite`, but, for the purposes of the walkthrough, let's keep going with `PostgreSQL`.

```bash
$ createdb yetibook_test
$ createdb yetibook_development
$ rails db:migrate
$ rails t
```

(The `createdb` command should've come with PostgreSQL.)

Our tests finally ran--but now there are different errors. Let's solve those and then write a test of our own.

### Fixing our tests
First, uncomment the `bcrypt` gem in our `Gemfile`.

Second, we need to update our fixtures. `Fixtures` are what Rails uses to populate our test database with data. Just go to `test/fixtures/yetis.yml`
and make sure that the data have different email addresses to quell the last error.

Now everything should be green!

### Writing a new test
Let's follow TDD and write a new test of our own.

In `test/models/yeti_test.rb`:
```ruby
def setup
  @minimum_valid_yeti = Yeti.new(name: 'new yeti',
                                     email: 'foo@example.com',
                                     password: 'abc123',
                                     password_confirmation: 'abc123')
end

test 'new yeti is invalid without an email' do
  invalid_member = @minimum_valid_yeti
  invalid_member[:email] = nil
  assert_not invalid_member.valid?
end
```

This test should fail with something that looks like this:
```bash
Failure:
Expected true to be nil or false
```

This failure occurred because our new `Yeti` was still **valid**. We don't want them to sign up without an email; how else can we send them spam?

So, following the spirit of TDD, let's update our `Yeti` model with the following:
`app/models/yeti.rb`
```ruby
validates :email,
    presence: true
```

Now do `rails t` and everything should be green again!

_We can put further validations on emails (e.g., has an @ symbol). You should explore this yourself._


## Building the Frontend

### Adding React
#### Gem
We'll use `react-rails` to fulfill our dependency on `React`. Add the following to your `Gemfile`.

```ruby
# React for front-end
gem 'react-rails', git: 'https://github.com/reactjs/react-rails.git', branch: 'master'
```

`bundle install` will add the `react-rails` gem to our project.

We'll also need to do

```bash
$ rails g react:install
```

#### Webpacker
We added `webpacker` at the beginning of the walkthrough. `Webpacker` combines all of our JavaScript components into one file so that it becomes easier to distribute to the end user. To make use of it, we need to copy

```
<%= javascript_pack_tag 'application' %>
```

into the header of `app/views/layouts/application.html.erb`.

Open a new terminal window and enter the following:

```bash
$ bin/webpack-dev-server
```

This gives us live reloading as we work on our React components.


#### Component
Let's create a simple component to view all of the Yetis who've signed up.

Create a new directory `app/javascript/components`.

Create a new file in that directory `Table.js`.

Add the following to `Table.js`:

```javascript
import React, { Component } from 'react';

const Table = () => {
   return (
     <table className="table">
       <thead>
         <tr>
           <th>Name</th>
           <th>Email</th>
         </tr>
       </thead>
       <tbody>
         <tr key="1">
           <td>Ice Berg</td>
           <td>ib@example.com</td>
         </tr>
         <tr key="2">
           <td>Glacial Pace</td>
           <td>gp@example.com</td>
         </tr>
       </tbody>
     </table>
   );
 }
 export default Table;
```

This table has no useful functionality yet, but we're just trying to get everything connected.

Add
```
<%= react_component("Table") %>
```
to `app/views/yetis/index.html.erb`.

Now you can go to `localhost:3000/yetis/index` to see our new table!


<!-- todo? -->
<!-- ### Adding Redux -->
<!-- Need a good case for when to use redux -->

<!-- todo -->
<!-- ### Writing a test -->

## Building GraphQL

### How to add GraphQL to Rails
There has to be a way to get data into our front-end. Static React components make for a pretty dull page, no? We'll use the `graphql` gem for this. Add the following to your `Gemfile`.

```ruby
# Use graphql for API
gem 'graphql', '~> 1.7'
```

Follow this up with another `bundle install`.

Now, under the `app` directory, create a folder called `graphql`.
Under that folder create two directories: `mutations` and `types`. We won't mess with mutations for now, but know that this is where they should go.

Create one more thing: inside of the `graphql` directory, you should create a file called `yetibook_scheme.rb`. The schema tells GraphQL where to go to find out how to respond to requests. Our file looks like this:

```ruby
YetibookSchema = GraphQL::Schema.define do
  mutation Types::MutationType
  query Types::QueryType
  # subscription Types::SubscriptionType
end
```
Again, `subscriptions` are another GraphQL type that we won't worry about right now.

You'll want to create a new directory called `types`. Then create `types/mutation_type.rb` and `types/query_type.rb`. This will serve as the entry points for queries and mutations. Ignoring `mutation_type` for now, put this into `query_type.rb`:

```ruby
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
      args[:name] ? [] << Yeti.find_by(name: args[:name]) : Yeti.all.to_a
    end
  end

end
```

So this makes a new query, called `yeti`, that we'll use to get grab info on the users of Yetibook. Please note that we use `types[Types::YetiType]` to indicate that this query always returns an array. If we weren't returning multiple objects, we could just do `Types:: YetiType`.

"But wait," you cry. "There's no `YetiType`!"

`types/yeti_type.rb`:
```ruby
Types::YetiType = GraphQL::ObjectType.define do
  name "Yeti"
  description 'A Yeti that shares all of its personal information.'

  # `!` marks a field as "non-null"
  field :id, !types.ID
  field :name, !types.String
  field :email, types.String
end
```

So now we need to see what we've done so far. Go to `localhost:3000/graphiql` (you may need to restart your Rails server).

Create a new Yeti if you haven't already like this:

```bash
$ rails c
$ Yeti.new(name: 'Abominable', email: 'snowman@yeti.com', password: 'abc123!@#').save
$ exit
```
Create as many as you want like this.

Now, here are two queries you can type in (click the big play button to run the query).

```graphql
{
  yeti {
    id
    name
    email
  }
}
```

```graphql
{
  yeti(name: "Abominable") {
    email
  }
}
```

See what we did there? We can change what data we get back from the query so that we only get what we need!

### How to add GraphQL to React via Apollo
We're so very, very close to actually having everything we need;
we just need to be able to see use GraphQL in React.

You're probably thinking, "New library; update the `Gemfile`."
Not so fast! Try doing

```bash
$ yarn add apollo-client apollo-cache-inmemory apollo-link-http react-apollo graphql-tag graphql
```

to add [Apollo][Apollo].

Create a new file in `app/javascript/components` called `ApolloClient.js`. Make sure that file mirrors the following:

```javascript
import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';

const client = new ApolloClient({
  link: new HttpLink({ uri: 'http://localhost:3000/graphql' }),
  cache: new InMemoryCache()
});
```

Create another file: `app/javascript/components/TableApp.js`:

```javascript
mport React, { Component } from 'react';
import { ApolloProvider } from 'react-apollo';
import { client } from './ApolloClient';
import TableWithData from './Table.js';

export default class TableApp extends Component {
   render() {
     return (
       <ApolloProvider client={client}>
         <TableWithData />
       </ApolloProvider>
     );
   }
 }
```

Update `app/views/yetisindex.html.erb` to:

```erb
<%= react_component("TableApp") %>
```

Then, finally we need to update `Table.js` to use Apollo.
You should do this yourself, but here's a hint:

```javascript
import React, { Component } from 'react';
import { graphql } from 'react-apollo';
import gql from 'graphql-tag';

export const Table = ({ data: {loading, error, yetis} }) => {...}

let YetiQuery  = gql`query { ... }`;
const TableWithData = graphql(YetiQuery)(Table);
export default TableWithData;
```

Good luck!



<!-- todo -->
<!-- ### Writing a test -->






_Phew!_ We've done a lot to help every yeti on the planet feel connected.


Please note for the following glossaries and links that they are included in the order in which they are written.
# Glossary of Terms

# Glossary of Commands

*__Version of Ruby on your path__*
```bash
ruby -v
```
or
```bash
ruby --version
```

*__Generating a new Rails project__*
```bash
rails new [project name]
```
See `rails new --help` for more detail.

*__Starting the PostgreSQL server__*
```bash
pg_ctl -D /path/to/db/files -l logfile start
```
(Usually, your path starts with `db/`)


# Links to docs

Presented in the order they are mentioned.

- Ruby: <https://ruby-doc.org/>

- rvm: <https://rvm.io/>

- Rubygems: <http://guides.rubygems.org/>

- Rails: <http://api.rubyonrails.org/>

- npm: <https://www.npmjs.com/>

- Yarn: <https://yarnpkg.com/en/>

- PostgreSQL: <https://www.postgresql.org/docs/>

- React: <https://reactjs.org/docs>

- GraphQL: <http://graphql.org/learn/>

- Apollo: <https://www.apollographql.com/docs/react/>




[Ruby]: https://ruby-doc.org/
[RubyGems]: https://rubygems.org/
[Rails]: https://rubyonrails.org/
[Homebrew]: https://brew.sh
[Apollo]: https://www.apollographql.com/
