// or, equivalent:
class NewOrder extends React.Component {
    constructor(){
        super();
        this.state = {showEditForm: false, orderId: 0};
    }

    createOrder(e, order){
        e.preventDefault();

        $.ajax(
            {
                url: '/orders',
                data: {order: order},
                type: 'POST',
                dataType: 'json',
                xhrFields: {
                    withCredentials: true
                },
                success: this.success.bind(this),
                error: this.fail.bind(this)
            }
        )


    }

    updateOrder(e, order){
        e.preventDefault();
        $.ajax(
            {
                url: '/orders/' + this.state,orderId,
                data: {order: order},
                type: 'PUT',
                dataType: 'json',
                xhrFields: {
                    'withCredentials': true
                },
                success: this.updateSuccess.bind(this),
                error: this.fail.bind(this)
            }
        )

    }

    success(response) {
        //console.log(response);
        this.state = {showEditForm: true, orderId: response.id};

    }
    updateSuccess(response) {
        //console.log(response);
        location.href = '/orders/new'
    }

    fail(err) {
        console.log(err)
        alert('Error occurred!');
    }



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
                                {this.state.showEditForm? 'End Order' : 'Start Order' }
                            </h3>
                        </div>
                    </div>

                </div>
                {!this.state.showEditForm && <StartOrderForm  submitForm={this.createOrder.bind(this)}  />}
                {this.state.showEditForm && <EditOrderForm submitForm={this.updateOrder.bind(this)} orderId={this.state.orderId} />}
            </div>
        )
    }
}