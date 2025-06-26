library(shiny)
library(shinydashboard)
library(dplyr)

dashboardPage(
  skin = "blue",
  
  dashboardHeader(title = "Avatar le maître du R"),
  
  dashboardSidebar(sidebarMenu(
    menuItem(
      "Statistiques",
      tabName = "statistiques",
      icon = icon("face-grin-stars")
    ),
    menuItem(
      "Graphique",
      tabName = "graphique",
      icon = icon("chart-line")
    ),
    menuItem("Navigateur", tabName = "navigateur", icon = icon("compass"))
  )),
  
  dashboardBody(tabItems(
    tabItem(
      tabName = "statistiques",
      
      h3("Nombre de jeux"),
      fluidRow(
        valueBoxOutput("box_total_games"),
        valueBoxOutput("box_indie_games"),
        valueBoxOutput("box_studio_games")
      ),
      
      h3("Avis des jeux indés"),
      fluidRow(
        valueBoxOutput("indie_overwhelmingly_positive"),
        valueBoxOutput("indie_very_positive"),
        valueBoxOutput("indie_mostly_positive"),
        valueBoxOutput("indie_mixed"),
        valueBoxOutput("indie_mostly_negative"),
        valueBoxOutput("indie_very_negative")
      ),
      
      h3("Avis des jeux studio"),
      fluidRow(
        valueBoxOutput("studio_overwhelmingly_positive"),
        valueBoxOutput("studio_very_positive"),
        valueBoxOutput("studio_mostly_positive"),
        valueBoxOutput("studio_mixed"),
        valueBoxOutput("studio_mostly_negative"),
        valueBoxOutput("studio_very_negative")
      )
    ),
    
    tabItem(
      tabName = "graphique",
      h3("Graphique d'interaction entre les jeux indés et studios"),
      fluidRow(
        box(
          width = 4,
          title = "Filtres",
          selectInput(
            "type_jeu",
            "Type de jeu :",
            choices = c("Tous", "Indé", "Studio"),
            selected = "Tous"
          ),
          radioButtons(
            "mode_affichage",
            "Afficher en :",
            choices = c("Pourcentage", "Nombre"),
            inline = TRUE
          ),
          checkboxInput("show_no_eval", "Inclure les jeux sans évaluation", value = TRUE)
        ),
        box(width = 8, title = "Répartition des avis utilisateurs", plotOutput("avis_plot"))
      )
    ),
    
    tabItem(tabName = "navigateur", fluidRow(
      box(
        width = 4,
        title = "Recherche développeur",
        selectizeInput(
          "selected_dev",
          "Choisir un développeur :",
          choices = NULL,
          multiple = FALSE
        )
      ),
      valueBoxOutput("dev_game_count", width = 8)
    ), fluidRow(
      box(
        width = 12,
        title = "Répartition des avis sur les jeux du développeur",
        plotOutput("dev_reviews_plot")
      )
    ))
  ))
)