class OrderMailer < ApplicationMailer
  def order(order_id)
    @order = Order.find(order_id)

    mail(to: @order.customer.email, subject: 'Спасибо!')
  end
end
