fluidPage(theme = shinytheme('cerulean'),
          tags$a(href = "https://github.com/Danielslee51/Calliope-View", tags$b("Github")),
          " | ",
          tags$a(href = "https://icons8.com", tags$b("Icon pack by Icons8")),
          title = ("Calliope View"),
          navbarPage(tags$b("Calliope-View"),
                     ####Tab 1: Includes the map, and key with features like filtering data####
                     tabPanel("Interactive Map",
                              sidebarLayout(
                                sidebarPanel(width = 6,
                                             tags$h4("Filter Drone Data"),
                                             checkboxInput(inputId = "only_neon", label = "Only include NEON"),
                                             selectInput(inputId = "Drone_site", label = "Filter by NEON Site", choices = unique(drone_data$neonSiteCode)[!(unique(drone_data$neonSiteCode) %in% NA)], selected = unique(drone_data$neonSiteCode), multiple = TRUE),
                                             tags$hr(),
                                             tags$h4("Browse NEON Data:"),
                                             tabsetPanel(
                                               tabPanel("Step 1- Find Data",
                                                        radioButtons(inputId = "NEON_browsing_type", label = "Browsing method", choices = list("Start with Site" = "site", "Start with Product" = "product")),
                                                        conditionalPanel("input.NEON_browsing_type == 'site'",
                                                                         includeMarkdown('Rmd/NEON_browsing_site.Rmd'),
                                                                         radioButtons(inputId = "NEONbrowsingstep_site", label = "Steps:", choices = list("Find Product" = "list", "Get Availability" = "single"), inline = TRUE),
                                                                         conditionalPanel("input.NEONbrowsingstep_site == 'list'",
                                                                                          selectInput(inputId = "NEONsite_site", label = "Select site:", choices = FieldSite_abbs),
                                                                                          tags$b("Data Products Available:"),
                                                                                          tags$br(),
                                                                                          tags$br(),
                                                                                          dataTableOutput(outputId = "NEONproductoptions_site")
                                                                         ),
                                                                         conditionalPanel("input.NEONbrowsingstep_site == 'single'",
                                                                                          textInput(inputId = "NEONproductID_site", label = "Product ID"),
                                                                                          tags$b("Name:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductname_site", placeholder = TRUE),
                                                                                          tags$b("Description:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductdesc_site", placeholder = TRUE),
                                                                                          tags$b("Available dates at this site:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductdates_site", placeholder = TRUE),
                                                                                          checkboxInput(inputId = "showURL_site", label = "Show Urls"),
                                                                                          conditionalPanel("input.showURL_site",
                                                                                                           tags$b("Available Urls:"),
                                                                                                           verbatimTextOutput("NEONproductURL_site", placeholder = TRUE)
                                                                                                           )
                                                                                          )
                                                        ),
                                                        conditionalPanel("input.NEON_browsing_type == 'product'",
                                                                         includeMarkdown('Rmd/NEON_browsing_product.Rmd'),
                                                                         radioButtons(inputId = "NEON_browsing_step_product", label = "Steps:", choices = list("Find Product" = "list", "Get Availability" = "single"), inline = TRUE),
                                                                         conditionalPanel("input.NEON_browsing_step_product == 'list'",
                                                                                          dataTableOutput(outputId = "NEON_product_options")
                                                                         ),
                                                                         conditionalPanel("input.NEON_browsing_step_product == 'single'",
                                                                                          textInput(inputId = "NEONproductID_product", label = "Product ID"),
                                                                                          tags$b("Name:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductname_product", placeholder = TRUE),
                                                                                          tags$b("Description:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductdesc_product", placeholder = TRUE),
                                                                                          uiOutput(outputId = "ui_product"),
                                                                                          tags$b("Available dates:"),
                                                                                          verbatimTextOutput(outputId = "NEONproductdates_product", placeholder = TRUE),
                                                                                          checkboxInput(inputId = "showURL_product", label = "Show Urls"),
                                                                                          conditionalPanel("input.showURL_product",
                                                                                                           tags$b("Available Urls:"),
                                                                                                           verbatimTextOutput("NEONproductURL_product", placeholder = TRUE)
                                                                                          )
                                                                         )
                                                        )
                                               ),
                                               tabPanel("Step 2- Download Data",
                                                        radioButtons(inputId = "NEON_download_type", label = "Download method", choices = list("By Data Product— General" = "general", "By Data Product— Specific" = "specific", "By Data Product— Manual" = "manual")),
                                                        conditionalPanel("input.NEON_download_type == 'general'",
                                                                         includeMarkdown('Rmd/NEON_download_general.Rmd'),
                                                                         textInput(inputId = "dpID_general", label = "Product ID"),
                                                                         selectInput(inputId = "location_NEON_general", label = "Field Site", choices = c("All (default)", unique(FieldSite_point$siteCode)), selected = "All (default)"),
                                                                         checkboxInput(inputId = "extra_options_general", label = "Show extra options"),
                                                                         conditionalPanel("input.extra_options_general",
                                                                                          selectInput(inputId = "package_type_general", label = "Package Type", choices = c("basic", "expanded"))),
                                                                         includeMarkdown('Rmd/NEON_download_message.Rmd'),
                                                                         actionButton(inputId = "download_NEON_general", label = "Download items")
                                                        ),
                                                        conditionalPanel("input.NEON_download_type == 'specific'",
                                                                         includeMarkdown('Rmd/NEON_download_specific.Rmd'),
                                                                         textInput(inputId = "dpID_specific", label = "Product ID"),
                                                                         selectInput(inputId = "location_NEON_specific", label = "Field Site", choices = unique(FieldSite_point$siteCode)),
                                                                         airMonthpickerInput(inputId = "date_NEON", label = "Year-Month combination"),
                                                                         checkboxInput(inputId = "extra_options_specific", label = "Show extra options"),
                                                                         conditionalPanel("input.extra_options_specific",
                                                                                          selectInput(inputId = "package_type_specific", label = "Package Type", choices = c("basic", "expanded"))),
                                                                         includeMarkdown('Rmd/NEON_download_message.Rmd'),
                                                                         actionButton(inputId = "download_NEON_specific", label = "Download items")
                                                        ),
                                                        conditionalPanel("input.NEON_download_type == 'manual'",
                                                                         includeMarkdown('Rmd/NEON_download_manual.Rmd')
                                                        )
                                               ),
                                               tabPanel("Step 3- Unzip/Join Downloads",
                                                        includeMarkdown('Rmd/NEON_unzip.Rmd'),
                                                        radioButtons(inputId = "NEON_unzip_type", label = "Method of browsing (from step 1)", choices = list("By Data Product— General/Specific" = "general/specific", "By Data Product— Manual" = "manual")),
                                                        tags$hr(),
                                                        conditionalPanel("input.NEON_unzip_type == 'general/specific'",
                                                                         includeMarkdown('Rmd/NEON_unzip_general:specific.Rmd'),
                                                                         directoryInput('NEON_unzip_folder', label = 'Select the directory', value = '..'),
                                                                         actionButton(inputId = "unzip_NEON_folder", label = "Unzip/join folder")
                                                        ),
                                                        conditionalPanel("input.NEON_unzip_type == 'manual'",
                                                                         includeMarkdown('Rmd/NEON_unzip_manual.Rmd'),
                                                                         selectInput(inputId = 'NEON_unzip_file', label = "Choose .zip file", choices = list.files(path = '..', pattern = ".zip")),
                                                                         actionButton(inputId = "unzip_NEON_file", label = "Unzip/join file")
                                                        )
                                               )
                                             )
                                ),
                                
                                mainPanel(width = 6,
                                          leafletOutput(outputId = "map", width = 'auto', height = '85vh')
                                )
                              )
                     ),
                     ####Tab 2: Description of project + contributors####
                     tabPanel("About the Calliope Project",
                              tabsetPanel(
                                tabPanel("About",
                                         includeMarkdown('Rmd/About Calliope.Rmd')),
                                tabPanel("Credits",
                                         includeMarkdown('Rmd/Credits.Rmd')))
                     ),
                     ####Tab 3: Display contents of drone data####
                     tabPanel("Drone Data",
                              tableOutput("Drone_table")),
                     ####Tab 4: Includes outputs to help with testing or troubleshooting####
                     tabPanel("For me (troubleshooting)",
                              textOutput("text_me"),
                              textOutput("text_me_two"),
                              dataTableOutput("table_me"))
          )
)