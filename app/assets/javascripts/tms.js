$(document).ready(function() {
	var sidebar_items = $("#sidebar");
	$("h2").each(function() {
		var item = $("<li></li>");
		var link = $("<a></a>");
		link.prop("href", "#"+this.id);
		var item_name;
		if (this.id == "project-title")
			item_name = "Project Title";
		else
			item_name = $(this).html();

		link.html(item_name);
		item.append(link);
		sidebar_items.append(item);
	});

	$("#sidebar li").first().addClass("active");
	$("body").scrollspy({ target: '#sidebar-nav'});
});