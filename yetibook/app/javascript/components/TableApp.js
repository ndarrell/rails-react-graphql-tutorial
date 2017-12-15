import React, { Component } from 'react';
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
