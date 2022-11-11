# load needed packages
library(shiny)
library(tidyverse)
library(medicaldata)
library(plotly)
library(markdown)

# make a name vector for plot3
rbc_names <- c("≤ 13 days (Younger)", 
               "13 - 18 days (Middle)", 
               "≥ 18 days (Older)")

# make a navigation layout
navbarPage("Data Challenge 4",
  # make the first tabpanel
  tabPanel("Plot1",
    # generate a row with a sidebar
    sidebarLayout(
      # define the sidebar
      sidebarPanel(
        # add instructions for how to use the app
        h4("Instructions:", style = "font-weight: bold"),
        p("The boxplot shows the values of a specific variable plotted by 
          three RBC Storage Duration Groups. We can choose which variable would
          be plotted. There are three options: Patient Age, Prostate Volume, 
          and Preoperative PSA. This plot is also made as a plotly one, 
          which means we can hover over specific data points."),
        
        selectInput("variable1", "Variable:", 
                    choices = c("Patient Age (year)", 
                                "Prostate Volume (g)", 
                                "Preoperative PSA (ng/mL)")
        )
      ),
      # create a spot for the boxplot
      mainPanel(
        h4("Blood Storage Data Introduction:", style = "font-weight: bold"),
        textOutput("desciption"),
        plotlyOutput("boxplot")
      )
    )
  ),
  # make the second tabpanel
  tabPanel("Plot2",
    # generate a row with a sidebar
    sidebarLayout(
      # define the sidebar
      sidebarPanel(
        # add app instructions
        h4("Instructions:", style = "font-weight: bold"),
        p("The barplot shows the number of different groups of
        a specific variable in each of the
          three RBC Storage Duration Groups. We can choose which variable would
          be plotted. There are four options: Family History of Disease,
          African American Race, Tumor Volume, and Biopsy Gleason Score. 
          This plot is also made as a plotly one, which means we can clearly
          see the count numbers of a specific group."),
        
        selectInput("variable2", "Variable:",
                    choices = c("African American Race", 
                                "Family History of Disease", 
                                "Tumor Volume", 
                                "Biopsy Gleason Score")
        )
      ),
      # create a spot for the barplot
      mainPanel(
        plotlyOutput("barplot")
      )
    )
  ),
  # make the third tabpanel
  tabPanel("Plot3",
    # generate a row with a sidebar
    sidebarLayout(
      # define the sidebar
      sidebarPanel(
        # add app instructions
        h4("Instructions:", style = "font-weight: bold"),
        p("The boxplot shows the values of Time to Biochemical Recurrence
          plotted by three RBC Storage Duration Groups (younger, middle, older).
          We can choose to plot the three RBC groups at one time or just to 
          plot a specific group or two groups.This plot is also made as a 
          plotly one, which means we can hover over specific data points."),
        
        checkboxGroupInput("variable3", "RBC Storage Duration Group:",
                         rbc_names,
                         selected = "≥ 18 days (Older)"
        )
      ),
      # create a spot for the barplot
      mainPanel(
        plotlyOutput("boxplot2")
      )
    )
  ) 
)
  










