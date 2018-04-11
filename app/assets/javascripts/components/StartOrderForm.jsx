class StartOrderForm extends React.Component {

    constructor(){
        super();
        this.state = {
            showFixedType: false,
            loading: false,
            order: {
                job_type: 'Time Tracking',
                fixed_type: 'Normal'
            }
        };
    }

    typeChanged(e) {
        //console.log(e.target.value);
        this.setState(
            {
                showFixedType: e.target.value === 'Fixed',
                order: { job_type: e.target.value}
            }
            );
    }

    fixedChanged(e) {
        this.setState(
            {
                // order: { job_type: this.state.order.value, fixed_type: e.target.value }
                order: { ...this.state.order,  fixed_type: e.target.value}
            }
        );
    }

    handleSubmit(e) {
        this.setState({loading: true})
        this.props.submitForm(e, this.props.order)
    }


    render() {
        return (
            <form className="m-form" >
                <div className="m-portlet__body">
                    <div className="form-group m-form__group">
                        <label  htmlFor="exampleSelect1">
                            Job Type
                        </label>
                        <select name="job_type" onChange={this.typeChanged.bind(this)} id="job_type2" className="form-control m-input m-input--air m-input--pill">
                            <option value="Time Tracking">Time Tracking (时间)</option>
                            <option value="Fixed">Fixed (工)</option>
                            <option value="Day">Day (天)</option>
                            <option value="O.N">O.N (夜)</option>
                        </select>
                    </div>
                    {this.state.showFixedType &&
                    <div className="form-group m-form__group" id="business">
                        <label htmlFor="exampleSelect1">
                            Type
                        </label>
                        <select name="fixed_type" id="fixed_type"
                                onChange={this.fixedChanged.bind(this)}
                                className="form-control m-input m-input--air m-input--pill">
                            <option value="Normal">Normal (普通)</option>
                            <option value="Hotel">Hotel (酒店)</option>
                        </select>
                    </div>

                    }
                </div>

                <div className="m-portlet__foot m-portlet__foot--fit">
                    <div className="m-form__actions m-form__actions">
                        <button disabled={this.state.loading} className="btn btn-success btn-block" onClick={(e) => this.handleSubmit(e)}>
                            Start {this.state.loading && <i className="fa fa-refresh fa-spin fa-fw"></i>}
                        </button>
                    </div>
                </div>
            </form>
        )
    }
}