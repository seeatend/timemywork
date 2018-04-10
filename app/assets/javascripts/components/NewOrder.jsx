// or, equivalent:
class NewOrder extends React.Component {
    render() {
        return (
            <div className="m-portlet">
                <div className="m-portlet__head">
                    <div className="m-portlet__head-caption">
                        <div className="m-portlet__head-title">
                            <span className="m-portlet__head-icon m--hide">
                                <i className="la la-gear"></i>
                            </span>
                            <h3 className="m-portlet__head-text">
                                Start Order
                            </h3>
                        </div>
                    </div>

                </div>

                <StartOrderForm />
            </div>
        )
    }
}