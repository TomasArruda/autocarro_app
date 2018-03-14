
export class BusesContainer extends React.Component {
  getInitialState(){
    return {
      buses: this.props.buses,
    }
  };

  parentBusSubmit(formData, onSuccess, onError){
    $.ajax({
      url: "/buses",
      dataType: 'json',
      type: 'POST',
      data: formData,
      success: function(buses) {
        this.setState({buses: buses});
        onSuccess();
      }.bind(this),
      error: function(response, status, err) {
        onError(response.responseJSON);
      }
    });
  };

  parentUpdateBus(formData, onSuccess, onError){
    $.ajax({
      url: ("/buses/" + formData["bus"]["id"]),
      dataType: 'json',
      type: 'PATCH',
      data: formData,
      success: function(buses) {
        this.setState({buses: buses, showNewForm: false});
        onSuccess();
      }.bind(this),
      error: function(response, status, err) {
        onError(response.responseJSON)
      }
    });
  };

  render() {
    return(
      <div>
        <h1> Bus List </h1>
        <BusTable buses={this.state.buses} parentUpdateBus={this.parentUpdateBus} />
        <NewBusForm parentBusSubmit={this.parentBusSubmit}/>
      </div>
    );
  }
};

export default BusesContainer