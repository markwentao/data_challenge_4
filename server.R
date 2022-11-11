# load needed packages
library(shiny)
library(tidyverse)
library(medicaldata)
library(plotly)
library(janitor)

# data cleaning 
ds <- blood_storage %>% 
  clean_names() %>% 
  # make sense the values
  mutate(fam_hx = case_when(fam_hx == 0 ~ "No family history of disease",
                            fam_hx == 1 ~ "Family history of disease"),
         rbc_age_group = case_when(rbc_age_group == 1 ~ "≤ 13 days (Younger)",
                                   rbc_age_group == 2 ~ "13 - 18 days (Middle)",
                                   rbc_age_group == 3 ~ "≥ 18 days (Older)"),
         aa = case_when(aa == 0 ~ "Non-African American",
                         aa == 1 ~ "African American"),
         t_vol = case_when(t_vol == 1 ~ "Low",
                           t_vol == 2 ~ "Medium",
                           t_vol == 3 ~ "Extensive"),
         b_gs = case_when(b_gs == 1 ~ "Score 0 - 6",
                          b_gs == 2 ~ "Score 7",
                          b_gs == 3 ~ "Score 8 - 10")) %>% 
  # rename some columns
  rename("Family History of Disease" = fam_hx,
         "African American Race" = aa,
         "Tumor Volume" = t_vol,
         "Biopsy Gleason Score" = b_gs,
         "Patient Age (year)" = age,
         "Prostate Volume (g)" = p_vol,
         "Preoperative PSA (ng/mL)" = preop_psa) %>% 
  # factor the rbc age group variable
  mutate(rbc_age_group = factor(rbc_age_group,
                                level = c("≤ 13 days (Younger)",
                                          "13 - 18 days (Middle)",
                                          "≥ 18 days (Older)")))

# define a server for the Shiny app
function(input, output) {
  
  # add data description
  
  output$desciption <- renderText({
    "This data set is from a study by 
    Cata et al. “Blood Storage Duration and Biochemical Recurrence of 
    Cancer after Radical Prostatectomy”, whcih is a retrospective Cohort Study 
    aiming to explore the association between red blood cells (RBC) 
    storage duration and biochemical prostate cancer recurrence after 
    radical prostatectomy. This dat set has 316 subjects and 20 variables. 
    Subjects are all men patients. Vairables include the main exposure: 
    RBC storage duration group, the outcome: time to biochemical 
    cancer recurrence, and a list of demographic, baseline 
    and prognostic factors. 
"
  })
  
  # make plot 1
  output$boxplot <- renderPlotly({
    # render a boxplot
    boxplot <- ggplot(data = ds,
                      aes(x = rbc_age_group,
                          y = get(input$variable1),
                          fill = rbc_age_group)) +
      geom_boxplot() +
      theme(legend.position = "none") +
      labs(x = "RBC Storage Duration Group",
           y = input$variable1, 
           title = "Boxplot of Different Variables by RBC Storage Duration Group") +
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    # make ggplot a plotly one
    ggplotly(boxplot)
  })
  
  # make plot 2
  output$barplot <- renderPlotly({
    # render a barplot
    barplot <- ggplot(data = ds,
                      aes(x = rbc_age_group,
                          fill = get(input$variable2))) +
      geom_bar(stat="count",
               position = "stack") +
      labs(x = "RBC Storage Duration Group",
           y = "Count",
           fill = input$variable2,
           title = "Barplot of RBC Storage Duration Group by Different Variables") +
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    # make ggplot a plotly one
    ggplotly(barplot)
  })
  
  # make plot 3
  output$boxplot2 <- renderPlotly({
    # fit in the input variables
    ds1 <- ds %>% 
      filter(rbc_age_group %in% input$variable3)
    # render a boxplot
    boxplot2 <- ggplot(data = ds1,
                      aes(x = rbc_age_group,
                          y = time_to_recurrence,
                          fill = rbc_age_group)) +
      geom_boxplot() +
      theme(legend.position = "none") +
      labs(x = "RBC Storage Duration Group",
           y = "Time to Biochemical Recurrence (month)",
           title = "Boxplot of Time to Biochemical Recurrence by RBC Storage Duration Group") +
      theme(plot.title = element_text(hjust = 0.5, face="bold"))
    # make ggplot a plotly one
    ggplotly(boxplot2)
  })
}
