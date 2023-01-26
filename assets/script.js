var all_relic_names = []

function init()
{
    color_values()
}



function color_values()
{
    var table = document.getElementById("items");
    for (var i = 1; i < table.rows.length; i++)
    {
        row = table.rows[i]

        plat = parseFloat(row.cells[1].textContent)
        if (plat >= 7.0 && plat < 15.0)
            row.cells[1].style.color = "#31bf60"
        else if (plat >= 15.0 && plat < 30.0)
            row.cells[1].style.color = "#98e546"
        else if (plat >= 30.0)
        {
            row.cells[1].style.color = "#e5dd47"
            row.cells[1].style.fontWeight = "bold"
        }

        ducats = parseInt(row.cells[3].textContent)
        if (ducats == 45)
            row.cells[3].style.color = "#49c4ff"
        else if (ducats == 100)
        {
            row.cells[3].style.color = "#49efff"
            row.cells[3].style.fontWeight = "bold"
        }

        ratio = parseFloat(row.cells[2].textContent)
        if (ratio >= 7.0 && ratio < 10.0)
            row.cells[2].style.color = "#98e546"
        else if (ratio >= 10.0)
        {
            row.cells[2].style.color = "#e5dd47"
            row.cells[2].style.fontWeight = "bold"
        }

    }
}



function filter_relic_tier(tier)
{
    if (tier === "")
        document.getElementById("search_bar").value = ""
    else
        document.getElementById("search_bar").value = tier + " "

    document.getElementById("search_bar").focus()

    update_results()
}



function update_results()
{
    search = document.getElementById("search_bar").value.trim()
    if (search.length === 1 || search.length === 2)
        return

    var table = document.getElementById("items");

    if (search === "")
    {
        for (var i = 1; i < table.rows.length; i++)
        {
            row = table.rows[i]
            row.style.display = "table-row";
        }
    }
    else if (search === "Lith" || search === "Meso" || search === "Neo" || search === "Axi")
    {
        var all_items = [] /* used to remove duplicates from seach results */

        for (var i = 1; i < table.rows.length; i++)
        {
            row = table.rows[i]
            relic = row.cells[4].textContent

            if (relic.indexOf(search) == -1)
                row.style.display = "none";
            else
            {
                name = row.cells[0].textContent

                if (! all_items.includes(name)) /* First time seeing this item, add it to the list */
                {
                    all_items.push(name)
                    row.style.display = "table-row";
                }
                else /* Item already in search results, hide it */
                    row.style.display = "none";
            }
        }
    }
    else if (search.match(/(Lith|Meso|Neo|Axi) [a-zA-Z][0-9]/) != null)
    {
        var all_items = [] /* used to remove duplicates from seach results */

        split = search.split(" ")
        search_tier = split.shift()
        search_types = split

        /* Uppercase relic types from the search bar */
        for (var i = 0; i < search_types.length; i++)
            search_types[i] = search_types[i].toUpperCase()

        for (var i = 1; i < table.rows.length; i++)
        {
            row = table.rows[i]
            relic_tier = row.cells[4].textContent.split(" ")[0]
            relic_type = row.cells[4].textContent.split(" ")[1]

            if (relic_tier === search_tier && search_types.includes(relic_type))
            {
                name = row.cells[0].textContent
                
                if (! all_items.includes(name)) /* First time seeing this item, add it to the list */
                {
                    all_items.push(name)
                    row.style.display = "table-row";
                }
                else /* Item already in search results, hide it */
                    row.style.display = "none";
            }
            else
                row.style.display = "none";
        }
    }
    else
    {
        for (var i = 1; i < table.rows.length; i++)
        {
            row = table.rows[i]
            name = row.cells[0].textContent.toLowerCase()
            relic = row.cells[4].textContent.toLowerCase()

            if ((name.indexOf(search) + relic.indexOf(search)) == -2)
                row.style.display = "none";
            else
                row.style.display = "table-row";
        }
    }
}



function add_to_opened(id)
{
    opened_table = document.getElementById("opened").children[1]
    row = document.getElementById(id).cloneNode(true)
    row.removeChild(row.lastElementChild)
    row.removeChild(row.lastElementChild)
    opened_table.appendChild(row)
}