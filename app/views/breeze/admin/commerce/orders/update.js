// Update the order line
// Nothing substantive to do here, just flash the row to confirm the action
$('tr[data-id="<%= @order.id %>"]').effect("highlight", { color: "#ffffc0" }, 3000);