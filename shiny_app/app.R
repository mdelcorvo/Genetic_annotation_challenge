library(shiny)
library(shinymanager)
library(shinyWidgets)
library(xlsx)
library(data.table)
options(warn=-1)

###########################################
# Lifebit Biotech Ltd - Coding Challenge  #
# 2022 Marcello Del Corvo 	          #
###########################################

inactivity <- "function idleTimer() {
var t = setTimeout(logout, 240000);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout() {
window.close();  //close the window
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();"

#Load results from example dataset analysis (original / imputed data.frame)
load('') # to edit
load('') # to edit
				    ##################
				    # Shiny UI -------
			            ##################
ui <- secure_app(head_auth = tags$script(inactivity),fluidPage(
  theme = "bootstrap.css",
  includeCSS("www/styles.css"),
  titlePanel(title=div(img(src="https://www.lifebit.ai/hubfs/Background-lines.png", height="100",width="1000"))),
  navbarPage("Lifebit Coding Challenge",id = "main_navbar",
  tabPanel(															    
	  "23andMe Genotyping Analysis",  													
	   fluidRow(),														
	   sidebarLayout(
		   sidebarPanel(width = 2,               
																			
            conditionalPanel(         #Original data#										
               condition = "input.original == 1",	
               pickerInput(inputId = "myPicker_original", label = "Select/deselect fields", choices = colnames(original)[7:ncol(original)], selected=colnames(original)[c(8,9:11,15)],
			   options = list(`actions-box` = TRUE,size = 10,`selected-text-format` = "count > 3"),multiple = TRUE),		
			   column(12,selectInput("geno_original","Genotype:",c("All", c('0/0','0/1','1/1')))),      
			   column(12, selectInput("clinvar_original","Only Clinical association",c("All",c('Only_Clinical')))),         
			   column(12, selectInput("clinical_original","Clinical Sign:",c("All",c('Benign','Pathogenic','association','risk_factor','drug_response')))), 
			   column(12, selectInput("gwas_original","Only GWAS studies",c("All",c('Only_GWAS')))),
               column(12, selectInput("cosmic_original","Only COSMIC ID",c("All",c('Only_COSMIC_ID')))),
               selectInput("field_original","Filter P.value/Risk Allele Freq:",c("",'P.val','Risk_Allele_Freq')), 
               column(6, textInput("x1_original", "Min", "")),
               column(6,textInput("x2_original", "Max", "")),
               column(12,selectInput("context_original","Context:",c("All", unique(original$Context)))),
			   downloadButton("downloadData_original", "Download"),),
																	 											
			conditionalPanel( #Imputed data#    
               condition = "input.original == 2",
               pickerInput(inputId = "myPicker_imputed", label = "Select/deselect fields", choices = colnames(imputed)[7:ncol(imputed)], selected=colnames(imputed)[c(8,9:11,15)],
			   options = list(`actions-box` = TRUE,size = 10,`selected-text-format` = "count > 3"),multiple = TRUE),		
			   column(12,selectInput("geno_imputed","Genotype:",c("All", c('0/0','0/1','1/1')))),      
			   column(12, selectInput("clinvar_imputed","Only Clinical association",c("All",c('Only_Clinical')))),         
			   column(12, selectInput("clinical_imputed","Clinical Sign:",c("All",c('Benign','Pathogenic','association','risk_factor','drug_response')))), 
			   column(12, selectInput("gwas_imputed","Only GWAS studies",c("All",c('Only_GWAS')))),
               column(12, selectInput("cosmic_imputed","Only COSMIC ID",c("All",c('Only_COSMIC_ID')))),
               selectInput("field_imputed","Filter P.value/Risk Allele Freq:",c("",'P.val','Risk_Allele_Freq')), 
               column(6, textInput("x1_imputed", "Min", "")),
               column(6,textInput("x2_imputed", "Max", "")),
               column(12,selectInput("context_imputed","Context:",c("All", unique(imputed$Context)))),
			   downloadButton("downloadData_imputed", "Download"),),
            ),
		   mainPanel(
			   width = 9,
			   tabsetPanel(id = 'dataset',
			   tabPanel("Example DataSet", tabsetPanel(id = 'original',
			   tabPanel("Original data", br(),DT::dataTableOutput("original"),value=1),		   
			   tabPanel("Imputed data",br(),DT::dataTableOutput("imputed"),value=2))))))),		   
		
	mainPanel(  
	width = 7,   
	uiOutput("data"),))))
					     ###########################
					     # Shiny Server Side -------
					     ###########################
																		
server <- function(input, output, session) {
  result_auth <- secure_server(check_credentials = check_credentials(credentials))														
  output$original <- DT::renderDataTable({ #original SNPS
	data <- original
	if (input$geno_original != "All") {data <- data[data$Genotype == input$geno_original,]}
    if (input$clinical_original != "All") {data <- data[grepl(input$clinical_original,data$ClinVar_Clinical_Sign,ignore.case=T),]}
    if (input$gwas_original != "All") {data <- data[data$Trait != '',]}  
    if (input$clinvar_original != "All") {data <- data[data$ClinVar_name != '',]}
    if (input$cosmic_original != "All") {data <- data[data$Cosmic != '',]} 
    if (input$field_original!= ''){f1<-input$field_original
		if (input$x1_original!=''){data<-subset(data,get(f1)>=input$x1_original)}
		if (input$x2_original!=''){data<-subset(data,get(f1)<=input$x2_original)}	
	}	
	if (input$context_original != "All") {data <- data[data$Context == input$context_original,]} 
    data_original <-data 
    if (ncol(data_original) ==18) {v1<- c('Snp_name','Chrom','Pos','REF','ALT','Genotype',input$myPicker_original)} else {v1<- input$myPicker_original}  				    
    doriginal<-data_original[, v1, drop = FALSE]   
    #download#
    output$downloadData_original <- downloadHandler(
    filename = function() {if (nrow(data_original) <= 1000) {paste(input$dataset,"_Original_SNPs", ".xlsx", sep = "")} else {paste(input$dataset,"_Original_SNPs", ".txt", sep = "")}},
    content = function(file) {if (nrow(data_original) <= 1000) {write.xlsx(doriginal, file, col.names = TRUE, row.names = F, append = FALSE)} else {fwrite(doriginal,file, row.names=F, col.names=T,quote=F, sep='\t')}}
    ) 
 
    DT::datatable(data_original[, v1, drop = FALSE], options = list(orderClasses = TRUE,lengthMenu = c(25, 50, 100, 500)))
  })
  
   output$imputed <- DT::renderDataTable({ #imputed SNPs
	data <- imputed
	if (input$geno_imputed != "All") {data <- data[data$Genotype == input$geno_imputed,]}
    if (input$clinical_imputed != "All") {data <- data[grepl(input$clinical_imputed,data$ClinVar_Clinical_Sign,ignore.case=T),]}
    if (input$gwas_imputed != "All") {data <- data[data$Trait != '',]}  
    if (input$clinvar_imputed != "All") {data <- data[data$ClinVar_name != '',]}
    if (input$cosmic_imputed != "All") {data <- data[data$Cosmic != '',]} 
    if (input$field_imputed!= ''){f1<-input$field_imputed
		if (input$x1_imputed!=''){data<-subset(data,get(f1)>=input$x1_imputed)}
		if (input$x2_imputed!=''){data<-subset(data,get(f1)<=input$x2_imputed)}	
	}	
	if (input$context_imputed != "All") {data <- data[data$Context == input$context_imputed,]} 
    data_imputed <-data 
    if (ncol(data_imputed) ==18) {v1<- c('Snp_name','Chrom','Pos','REF','ALT','Genotype',input$myPicker_imputed)} else {v1<- input$myPicker_imputed}  				    
    dimputed<-data_imputed[, v1, drop = FALSE]   
    #download#
    output$downloadData_imputed <- downloadHandler(
    filename = function() {if (nrow(data_imputed) <= 1000) {paste(input$dataset,"_Imputed_SNPs", ".xlsx", sep = "")} else {paste(input$dataset,"_Imputed_SNPs", ".txt", sep = "")}},
    content = function(file) {if (nrow(data_imputed) <= 1000) {write.xlsx(dimputed, file, col.names = TRUE, row.names = F, append = FALSE)} else {fwrite(dimputed,file, row.names=F, col.names=T,quote=F, sep='\t')}}
    ) 
  
    DT::datatable(data_imputed[, v1, drop = FALSE], options = list(orderClasses = TRUE,lengthMenu = c(25, 50, 100, 500)))
  })
}

# data.frame with credentials info (to edit)
credentials <- data.frame(
  user = c(""),
  password = c(""),
  stringsAsFactors = FALSE
)

# Run the application
shinyApp(ui = ui, server = server)
