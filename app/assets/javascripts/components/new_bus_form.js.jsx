export class NewBusForm extends React.Component {
  getInitialState(){
    return {registration_number: "", formErrors: {}};
  }

  resetState(){
    this.setState({registration_number: "", formErrors: {}});
  }

  handleValidationError(formErrorObj){
    this.setState({formErrors: formErrorObj});
  }

  newBusSubmit(e){
    e.preventDefault();
    this.props.parentBusSubmit(
      {
        bus: {
          registration_number: this.state.registration_number
        }
      },
      this.resetState,
      this.handleValidationError
    );
  }

  handleRegistrationNumberChange(e){
    this.setState({registration_number: e.target.value});
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

  renderBusRegistrationNumberField(){
    var formGroupClass = this.state.formErrors["registration_number"] ? "form-group has-error" : "form-group"

    return(
      <div className='row'>
        <div className='col-sm-4'>
          <div className= 'form-group'>
            <div className= {formGroupClass}>
              <input
                name="bus[registration_number]"
                type="string"
                placeholder="Bus Registration Number"
                value={this.state.registration_number}
                onChange={this.handleRegistrationNumberChange}
                className="string form-control"
              />
            </div>
          </div>
        </div>
      </div>
    );
  }

  render() {
    return(
      <div>
        <h4 style={{marginTop: "50px"}}> Create New Bus </h4>
        <form style={{marginTop: "30px"}} onSubmit={this.newBusSubmit}>
          <div className='form-inputs'/>
            {this.renderBusRegistrationNumberField()}
            <div className='row'>
              <div className='col-sm-4'>
                <input type="submit" value="Save" className='btn btn-primary' />
              </div>
            </div>
        </form>
      </div>
    );
  }
};

export default NewBusForm