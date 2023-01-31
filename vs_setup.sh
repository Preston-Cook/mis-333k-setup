#!bin/bash

# Store current folder name
current_dir=$(basename "$PWD")
echo "Retrieved Basename from Absolute Path"

# Create Directories
mkdir Models Controllers Views Views/Home Views/Shared wwwroot wwwroot/images wwwroot/js wwwroot/css
echo "Created Directories"

# Touch necessary files
touch wwwroot/css/styles.css wwwroot/js/scripts.js Views/Home/index.cshtml
echo "Created Empty Files"

# Add text to Program.cs
cat > Program.cs <<- EOM
// add a using statement for currency
using System.Globalization;

// create a web application builder
var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllersWithViews();

// build the app
var app = builder.Build();

// These lines allow you to see more detailed error messages
app.UseDeveloperExceptionPage();
app.UseStatusCodePages();

// This line allows you to use static pages like style sheets and images
app.UseStaticFiles();

/* This marks the position in the middleware pipeline where a 
 * routing decision is made for a URL */
app.UseRouting();

// This allows the data annotations for currency to work on Macs
app.Use(async (context, next) =>
{
    CultureInfo.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en- US");
    CultureInfo.CurrentUICulture = CultureInfo.CurrentCulture;
    await next.Invoke();
});

//TODO: (HW4 & Beyond) Once you have added Identity into your project, you will //need to uncomment these lines
//app.UseAuthentication();
//app.UseAuthorization();

//This method maps the controllers and their actions to a patter for //requests that's known as the default route. This route identifies //the Home controller as the default controller and the Index() action //method as the default action. The default route also identifies a //third segment of the URL that's a parameter named id. app.MapControllerRoute(
app.MapControllerRoute(
name: "default",
pattern: "{controller=Home}/{action=Index}/{id?}");
app.Run();
EOM

echo "Wrote to Program.cs"

# Add sample model to Model dir
cat > Models/SampleModel.cs <<- EOM
using System;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.Metrics;

namespace ${current_dir}.Models
{
    public class SampleModel
    {
        // Insert model here
    }
}
EOM

echo "Wrote to Models/SampleModel.cs"

# Add boiler plate to Controllers/HomeController.cs
cat > Controllers/HomeController.cs <<- EOM
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ${current_dir}.Models;
using Microsoft.AspNetCore.Mvc;

namespace ${current_dir}.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
EOM

echo "Wrote to Controllers/HomeController.cs"

# Add text to Views/_ViewImports.cshtml
cat > Views/_ViewImports.cshtml <<- EOM
@namespace ${current_dir}.Views
@using ${current_dir}.Models
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
EOM

echo "Wrote to Views/_ViewImports.cshtml"

# Add text to Views/_ViewStart.cshtml
cat > Views/_ViewStart.cshtml <<- EOM
@{
    Layout = "_Layout";
}
EOM

echo "Wrote to Views/_ViewStart.cshtml"

# Add text to Views/Shared/_Layout.cshtml
cat > Views/Shared/_Layout.cshtml <<- EOM
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width" />
    <meta charset="UTF-8">
    <title></title>
</head>
<body>
    <div class="container">
        @RenderBody()
    </div>
</body>
</html>
EOM

echo "Wrote to Views/Shared/_Layout.cshtml"

# Success Message
echo "Successfully Ran with 0 Errors :)"