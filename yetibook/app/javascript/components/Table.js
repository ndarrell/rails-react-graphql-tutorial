import React, { Component } from 'react';
import { graphql } from 'react-apollo';
import gql from 'graphql-tag';

export const Table = ({ data: {loading, error, yeti} }) => {

  const renderTableHeader = () => {
    return(
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
        </tr>
      </thead>
    );
  }

  const renderTableBody = (yetiArray) => {
    let dataRows = yetiArray.map((yeti) => {
      return renderTableRow(yeti);
    });
    return(
      <tbody>
        {dataRows}
      </tbody>
    );
  }

  const renderTableRow = (yetiObject) => {
    return(
      <tr key={yetiObject.id}>
        <td>{yetiObject.name}</td>
        <td>{yetiObject.email}</td>
      </tr>
    );
  }
  if (loading) return <p> Please wait...</p>;
  if (error) return <div className="alert alert-danger" role="alert">{error.message}</div>;

  return (
    <table className="table">
      {renderTableHeader()}
      {renderTableBody(yeti)}
    </table>
  );
}

let YetiQuery  = gql`query YetiIndexQuery { yeti { id, name, email } }`;
const TableWithData = graphql(YetiQuery)(Table);
export default TableWithData;
