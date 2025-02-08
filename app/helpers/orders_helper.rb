module OrdersHelper
  def order_status_color(status)
    case status
    when 'processing'
      'bg-yellow-100 text-yellow-800'
    when 'packing'
      'bg-blue-100 text-blue-800'
    when 'transit'
      'bg-purple-100 text-purple-800'
    when 'delivered'
      'bg-green-100 text-green-800'
    when 'cancelled'
      'bg-red-100 text-red-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def return_request_status_color(status)
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'approved'
      'bg-green-100 text-green-800'
    when 'rejected'
      'bg-red-100 text-red-800'
    when 'completed'
      'bg-blue-100 text-blue-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end

  def order_status_icon(status)
    case status
    when 'processing'
      'fa-clock'
    when 'packing'
      'fa-box'
    when 'transit'
      'fa-truck'
    when 'delivered'
      'fa-check-circle'
    when 'cancelled'
      'fa-times-circle'
    else
      'fa-question-circle'
    end
  end
end
