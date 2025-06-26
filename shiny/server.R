library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
library(shinydashboard)

server <- function(input, output, session) {
  # Initialisation des données
  games <- read_csv2("../data/clean_games.csv")
  tags <- read_csv("../data/tags.csv")
  steamspy <- read_csv("../data/steamspy.csv")
  reviews <- read_csv("../data/raw_reviews.csv")
  
  steamspy$app_id <- as.character(steamspy$app_id)
  reviews$app_id <- as.character(reviews$app_id)
  tags$app_id <- as.character(tags$app_id)
  games$app_id <- as.character(games$app_id)
  
  data <- games %>%
    left_join(steamspy, by = "app_id") %>%
    left_join(reviews, by = "app_id") %>%
    left_join(tags, by = "app_id")
  
  # Définition des données
  indie_games <- data %>%
    filter(tag == "Indie") %>%
    distinct(app_id, .keep_all = TRUE)
  
  studio_games <- data %>%
    filter(!app_id %in% indie_games$app_id) %>%
    distinct(app_id, .keep_all = TRUE)
  
  # Fonction de pourcentage
  review_percent <- function(data, score) {
    allowed_scores <- c(
      "Very Negative",
      "Mostly Negative",
      "Mixed",
      "Mostly Positive",
      "Very Positive",
      "Overwhelmingly Positive"
    )
    
    filtered <- data %>%
      filter(review_score_description %in% allowed_scores)
    
    if (nrow(filtered) == 0)
      return(0)
    
    round(
      100 * sum(filtered$review_score_description == score, na.rm = TRUE) / nrow(filtered),
      1
    )
  }
  
  # Statistiques
  
  output$box_total_games <- renderValueBox({
    valueBox(
      value = n_distinct(data$app_id),
      subtitle = "Nombre total de jeux",
      icon = icon("gamepad"),
      color = "blue"
    )
  })
  
  output$box_indie_games <- renderValueBox({
    valueBox(
      value = n_distinct(indie_games$app_id),
      subtitle = "Jeux Indé",
      icon = icon("star"),
      color = "blue"
    )
  })
  
  output$box_studio_games <- renderValueBox({
    valueBox(
      value = n_distinct(studio_games$app_id),
      subtitle = "Jeux Studio",
      icon = icon("building"),
      color = "blue"
    )
  })
  
  # Avis des jeux indés
  output$indie_overwhelmingly_positive <- renderValueBox({
    valueBox(
      paste0(
        review_percent(indie_games, "Overwhelmingly Positive"),
        "%"
      ),
      subtitle = "Extrêmement Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$indie_very_positive <- renderValueBox({
    valueBox(
      paste0(review_percent(indie_games, "Very Positive"), "%"),
      subtitle = "Très Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$indie_mostly_positive <- renderValueBox({
    valueBox(
      paste0(review_percent(indie_games, "Mostly Positive"), "%"),
      subtitle = "Plutôt Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$indie_mixed <- renderValueBox({
    valueBox(
      paste0(review_percent(indie_games, "Mixed"), "%"),
      subtitle = "Moyenne",
      icon = icon("thumbs-up"),
      color = "orange"
    )
  })
  
  output$indie_mostly_negative <- renderValueBox({
    valueBox(
      paste0(review_percent(indie_games, "Mostly Negative"), "%"),
      subtitle = "Plutôt Négative",
      icon = icon("thumbs-up"),
      color = "red"
    )
  })
  
  output$indie_very_negative <- renderValueBox({
    valueBox(
      paste0(review_percent(indie_games, "Very Negative"), "%"),
      subtitle = "Très Négative",
      icon = icon("thumbs-up"),
      color = "red"
    )
  })
  
  # Avis des jeux studios
  output$studio_overwhelmingly_positive <- renderValueBox({
    valueBox(
      paste0(
        review_percent(studio_games, "Overwhelmingly Positive"),
        "%"
      ),
      subtitle = "Extrêmement Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$studio_very_positive <- renderValueBox({
    valueBox(
      paste0(review_percent(studio_games, "Very Positive"), "%"),
      subtitle = "Très Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$studio_mostly_positive <- renderValueBox({
    valueBox(
      paste0(review_percent(studio_games, "Mostly Positive"), "%"),
      subtitle = "Plutôt Positive",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  output$studio_mixed <- renderValueBox({
    valueBox(
      paste0(review_percent(studio_games, "Mixed"), "%"),
      subtitle = "Moyenne",
      icon = icon("thumbs-up"),
      color = "orange"
    )
  })
  
  output$studio_mostly_negative <- renderValueBox({
    valueBox(
      paste0(review_percent(studio_games, "Mostly Negative"), "%"),
      subtitle = "Plutôt Négative",
      icon = icon("thumbs-up"),
      color = "red"
    )
  })
  
  output$studio_very_negative <- renderValueBox({
    valueBox(
      paste0(review_percent(studio_games, "Very Negative"), "%"),
      subtitle = "Très Négative",
      icon = icon("thumbs-up"),
      color = "red"
    )
  })
  
  # Graphique
  
  output$avis_plot <- renderPlot({
    # Les scores des avis de Steam
    allowed_scores <- c(
      "Very Negative",
      "Mostly Negative",
      "Mixed",
      "Mostly Positive",
      "Very Positive",
      "Overwhelmingly Positive"
    )
    
    selected_data <- switch(
      input$type_jeu,
      "Indé" = indie_games,
      "Studio" = studio_games,
      "Tous" = bind_rows(indie_games, studio_games)
    )
    
    # On ajoute "No Evaluation" pour remplacer les valeurs en dehors des scores définis
    selected_data <- selected_data %>%
      mutate(
        review_score_description = ifelse(
          review_score_description %in% allowed_scores,
          review_score_description,
          "No Evaluation"
        )
      )
    
    if (!input$show_no_eval) {
      selected_data <- selected_data %>%
        filter(review_score_description != "No Evaluation")
    }
    
    avis_counts <- selected_data %>%
      group_by(review_score_description) %>%
      summarise(n = n()) %>%
      ungroup()
    
    # On réorganise l'ordre
    avis_counts$review_score_description <- factor(
      avis_counts$review_score_description,
      levels = c(
        "No Evaluation",
        "Very Negative",
        "Mostly Negative",
        "Mixed",
        "Mostly Positive",
        "Very Positive",
        "Overwhelmingly Positive"
      )
    )
    
    if (input$mode_affichage == "Pourcentage") {
      avis_counts <- avis_counts %>%
        mutate(pct = round(100 * n / sum(n), 1))
      
      ggplot(avis_counts, aes(x = review_score_description, y = pct)) +
        geom_col(fill = "#0072B2") +
        geom_text(aes(label = paste0(pct, "%")), vjust = -0.5) +
        labs(
          title = paste("Répartition des avis -", input$type_jeu),
          x = "Type d'avis",
          y = "Pourcentage de jeux"
        ) +
        theme_minimal()
      
    } else {
      ggplot(avis_counts, aes(x = review_score_description, y = n)) +
        geom_col(fill = "#D55E00") +
        geom_text(aes(label = n), vjust = -0.5) +
        labs(
          title = paste("Répartition des avis -", input$type_jeu),
          x = "Type d'avis",
          y = "Nombre de jeux"
        ) +
        theme_minimal()
    }
  })
  
  # Navigateur
  
  observe({
    allowed_scores <- c(
      "Very Negative", "Mostly Negative", "Mixed",
      "Mostly Positive", "Very Positive", "Overwhelmingly Positive"
    )
    
    devs_with_reviews <- data %>%
      filter(review_score_description %in% allowed_scores) %>%
      filter(!is.na(developer)) %>%
      distinct(developer) %>%
      pull(developer) %>%
      sort()
    
    updateSelectizeInput(
      session, "selected_dev",
      choices = devs_with_reviews,
      server = TRUE
    )
  })
  
  output$dev_game_count <- renderValueBox({
    req(input$selected_dev)
    
    dev_game_total <- data %>%
      filter(developer == input$selected_dev) %>%
      distinct(app_id) %>%
      nrow()
    
    valueBox(
      value = dev_game_total,
      subtitle = paste("Jeux développés par", input$selected_dev),
      icon = icon("laptop-code"),
      color = "blue"
    )
  })
  
  output$dev_reviews_plot <- renderPlot({
    req(input$selected_dev)
    
    allowed_scores <- c(
      "Very Negative",
      "Mostly Negative",
      "Mixed",
      "Mostly Positive",
      "Very Positive",
      "Overwhelmingly Positive"
    )
    
    # On convertit en caractère
    dev_games <- data %>%
      filter(developer == input$selected_dev) %>%
      distinct(app_id, .keep_all = TRUE) %>%
      mutate(
        review_score_description = as.character(review_score_description),
        review_score_description = ifelse(
          review_score_description %in% allowed_scores,
          review_score_description,
          "No Evaluation"
        )
      )
    
    avis_counts <- dev_games %>%
      group_by(review_score_description) %>%
      summarise(n = n()) %>%
      ungroup() %>%
      mutate(
        review_score_description = factor(
          review_score_description,
          levels = c(
            "No Evaluation",
            "Very Negative",
            "Mostly Negative",
            "Mixed",
            "Mostly Positive",
            "Very Positive",
            "Overwhelmingly Positive"
          )
        ),
        pct = round(100 * n / sum(n), 1)
      )
    
    ggplot(avis_counts, aes(x = review_score_description, y = pct)) +
      geom_col(fill = "#0072B2") +
      geom_text(aes(label = paste0(pct, "%")), vjust = -0.5) +
      labs(
        title = paste("Avis sur les jeux de", input$selected_dev),
        x = "Type d'avis",
        y = "Pourcentage de jeux"
      ) +
      theme_minimal()
  })
}
