module ApplicationHelper
  def money(amount)
    number_to_currency(amount || 0,
      unit: "Gs. ",
      format: "%u%n",
      precision: 0,
      separator: ",",
      delimiter: ".")
  end

  def simple_date(datetime)
    datetime.present? ? I18n.l(datetime, format: :short) : ""
  end

  def nav_item_active?(path)
    request.path == path || (path != "/" && request.path.start_with?(path))
  end

  def sidebar_link(label, path, icon:)
    active = nav_item_active?(path)
    classes = active ? "bg-slate-800 text-white" : "text-slate-300 hover:bg-slate-800 hover:text-white"
    link_to path, class: "flex items-center gap-3 rounded-lg px-3 py-2 #{classes}" do
      concat sidebar_icon(icon)
      concat content_tag(:span, label)
    end
  end

  def sidebar_icon(name)
    # rubocop:disable Layout/LineLength
    paths = {
      dashboard: '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/>',
      sales: '<path d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>',
      products: '<path d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9"/>',
      categories: '<path d="M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z"/>',
      customers: '<path d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z"/>',
      suppliers: '<path d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 00-3.213-9.193 2.056 2.056 0 00-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 00-10.026 0 1.106 1.106 0 00-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12"/>',
      movements: '<path d="M7.5 21L3 16.5m0 0L7.5 12M3 16.5h13.5m0-13.5L21 7.5m0 0L16.5 12M21 7.5H7.5"/>',
      employees: '<path d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.45-.037.666A9.122 9.122 0 0112 18.75a9.122 9.122 0 01-5.965-2.076c-.025-.216-.037-.441-.037-.666 0-.011.001-.022.001-.032A3 3 0 0012 15.75a3 3 0 000-6.66A3 3 0 013.259 8.52M15.75 3.75v3m0-3a5.25 5.25 0 100 10.5 5.25 5.25 0 000-10.5z"/>'
    }.fetch(name) { "" }

    content_tag(:svg, (paths.html_safe), class: "h-5 w-5 shrink-0", fill: "none", viewBox: "0 0 24 24", "stroke-width" => "1.5", stroke: "currentColor")
    # rubocop:enable Layout/LineLength
  end

  def field_classes
    # rubocop:disable Layout/LineLength
    "w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
  end

  def field_classes_error
    "w-full rounded-lg border border-red-400 bg-white px-3 py-2 text-sm text-slate-800 shadow-sm focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-200"
    # rubocop:enable Layout/LineLength
  end

  def label_classes
    "mb-1 block text-sm font-medium text-slate-700"
  end

  def button_classes(variant = :primary)
    base = "inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-semibold transition"
    case variant
    when :primary then "#{base} bg-blue-600 text-white shadow-sm hover:bg-blue-700"
    when :secondary then "#{base} bg-white text-slate-700 ring-1 ring-slate-300 hover:bg-slate-50"
    when :danger then "#{base} bg-red-600 text-white shadow-sm hover:bg-red-700"
    end
  end

  def card_classes
    "rounded-xl border border-slate-200 bg-white shadow-sm"
  end

  def badge_color(type)
    case type.to_s
    when "purchase" then "bg-blue-100 text-blue-700"
    when "sale" then "bg-emerald-100 text-emerald-700"
    when "adjustment" then "bg-amber-100 text-amber-700"
    when "return" then "bg-purple-100 text-purple-700"
    else "bg-slate-100 text-slate-700"
    end
  end

  def movement_type_options
    {
      "Compra (suma stock)" => "purchase",
      "Venta (resta stock)" => "sale",
      "Ajuste (puede sumar o restar)" => "adjustment",
      "Devolución (suma stock)" => "return"
    }
  end
end