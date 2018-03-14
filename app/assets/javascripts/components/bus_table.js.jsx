export class BusTable extends React.Component {
  renderBusRows(){
    return(
      this.props.buses.map(function(bus){
        return(
          <BusRow
            key={bus.id}
            id={bus.id}
            registration_number={bus.registration_number}
            parentUpdateBus={this.props.parentUpdateBus} />
        );
      }.bind(this))
    );
  }

  render() {
    return(
      <div>
        <div className="row" style={{marginTop: "50px"}}>
          <div className="col-sm-2">
          </div>
          <div className="col-sm-2" style={{fontWeight: "bold"}}>
            Registration Number
          </div>
        </div>
        {this.renderBusRows()}
      </div>
    );
  }
};

export default BusTable