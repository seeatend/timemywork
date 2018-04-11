class EditOrderForm extends React.Component {
    constructor() {
        super();
        this.state = {
            showFixedType: false,
            loading: false,
            order: {
                status: 'Cash',
                creditor_name: ''
            }
        };
    }
    typeChanged(e) {
        this.setState(
            {
                showFixedType: e.target.value === 'Credit',
                order: { status: e.target.value}
            }
        );
    }

    creditorNameChanged(e) {
        this.setState(
            {
                // order: { job_type: this.state.order.value, fixed_type: e.target.value }
                order: { ...this.state.order,  creditor_name: e.target.value}
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
                            Status
                        </label>
                        <select name="status" onChange={(e) => this.typeChanged(e) } className="form-control m-input m-input--air m-input--pill">
                            <option value="Cash">Cash (现金)</option>
                            <option value="Credit">Credit (挂单)</option>
                        </select>
                    </div>
                    {this.state.showFixedType &&
                    <div className="form-group m-form__group" >

                        <label htmlFor="exampleSelect1">
                            Type
                        </label>
                        <input type="text" onChange={this.creditorNameChanged.bind(this)} name="creditor_name" id="creditor_name" className="form-control m-input" placeholder="名字 ／ 代号" />

                    </div>
                    }
                </div>

                <div className="m-portlet__foot m-portlet__foot--fit">
                    <div className="m-form__actions m-form__actions">
                        <button disabled={this.state.loading}  className="btn btn-danger btn-block" onClick={(e) => this.handleSubmit(e)}>
                            End {this.state.loading && <i className="fa fa-refresh fa-spin fa-fw"></i>}
                        </button>
                    </div>
                </div>

            </form>
        )
    }

}