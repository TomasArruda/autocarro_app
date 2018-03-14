
export class BusRow extends React.Component {
  getInitialState(){
    return ( 
      {
        id: this.props.id, 
        registration_number: this.props.registration_number, 
        edit: false, 
        formErrors: {}
      } 
    )
  }

  editBus(){
    this.setState(
      {
        edit: true
      }
    );
  }

  cancelEdit(e){
    e.preventDefault();
    this.setState(
      {
        edit: false, 
        registration_number: this.props.registration_number, 
        formErrors: {}
      }
    );
  }

  handleRegistrationNumberChange(e){
    this.setState(
      {
        registration_number: e.target.value
      }
    );
  }

  handleValidationErrors(formErrorObject){
    this.setState(
      {
        edit: true, formErrors: formErrorObject
      }
    );
  }

  handleUpdate(){
    this.setState(
      {
        edit: false, formErrors: false
      }
    );
  }

  updateBus(e){
    e.preventDefault();
    this.props.parentUpdateBus(
      {
        bus: {
          id: this.state.id, 
          registration_number: this.props.registration_number
        }
      },
      this.handleUpdate,
      this.handleValidationErrors
    );
  }

  renderFieldErrors(attribute){
    if(this.state.formErrors[attribute]){
      return(
        this.state.formErrors[attribute].map(function(error, i){
          return(
            <span key={i} className="help-block">
              {error}
            </span>
          );
        })
      );
    }
    else{
      return "";
    }
  }

  renderBusRegistrationNumberEditFields(){
    var formGroupClass = this.state.formErrors["registration_number"] ? "form-group has-error" : "form-group"
    return(
      <div className= {formGroupClass}>
        <input
          name="bus[registration_number]"
          type="string"
          placeholder="Bus Registration Number"
          value={this.state.registration_number}
          onChange={this.handleRegistrationNumberChange}
          className="string form-control"
        />
        {this.renderFieldErrors("registration_number")}
      </div>
    );
  }


  render() {
    if(this.state.edit == false){
      return(
        <div className="row" style={{marginTop: "20px"}}>
          <div className="col-sm-2">
            <button className='btn btn-sm btn-primary' onClick={this.editBus}>
              Edit Bus
            </button>
          </div>
          <div className="col-sm-2">
            {this.state.registration_number}
          </div>
        </div>
      );
    }
    else{
      return(
        <div className="row" style={{marginTop: "20px"}}>
          <form style={{marginTop: "30px"}} onSubmit={this.updateBus}>
            <div className="col-sm-2">
              <input type="submit" value="Save" className='btn btn-success' />
              <button className='btn btn-sm btn-primary' style={{marginLeft:'10px'}} onClick={this.cancelEdit}>
                Cancel
              </button>
            </div>
            <div className="col-sm-2">
              {this.renderBusRegistrationNumberEditFields()}
            </div>
          </form>
        </div>
      );
    }
  }
};

export default BusRow