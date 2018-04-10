class NewOrder extends React.Component {

    constructor(){
        super();
        this.state = {showFixedType: false};
    }

    typeChanged(e) {
        //console.log(e.target.value);
        this.setState({showFixedType: e.target.value === 'Fixed'});
    }


    render() {
        return (
            <form className="m-form">
                <div className="m-portlet__body">
                    <div className="form-group m-form__group">
                        <label  htmlFor="exampleSelect1">
                            Job Type
                        </label>
                        <select name="job_type" onChange={(e) => this.typeChanged(e) } id="job_type2" className="form-control m-input m-input--air m-input--pill">
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
                        <select name="job_type" id="job_type"
                                className="form-control m-input m-input--air m-input--pill">
                            <option value="Normal">Normal (普通)</option>
                            <option value="Hotel">Hotel (酒店)</option>
                        </select>
                    </div>

                    }
                </div>

                <div className="m-portlet__foot m-portlet__foot--fit">
                    <div className="m-form__actions m-form__actions">
                        <button className="btn  btn-success btn-block">Start</button>
                    </div>
                </div>

            </form>
        )
    }
}