VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmJobData 
   Caption         =   "Job Data"
   ClientHeight    =   6450
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6915
   OleObjectBlob   =   "frmJobData.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmJobData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub cmdCancel_Click()
    
    Me.Hide
    
End Sub

Private Sub cmdOK_Click()

    SaveJobData
    Me.Hide
    
End Sub
Public Sub SaveJobData()

    If Scanner.Job Is Nothing Then
        Set Scanner.Job = New Job
    End If
    
    Scanner.Job.JobName = Me.txtJobName
    Scanner.Job.SiteLocation = Me.txtSiteLocation
    Scanner.Job.LeadN = Me.txtLeadN
    Scanner.Job.StaticPressure = Me.txtStaticPressure
    Scanner.Job.ResidualPressure = Me.txtResidualPressure
    Scanner.Job.AvailableFlow = Me.txtAvailableFlow
    Scanner.Job.MeterElevation = Me.txtMeterElevation
    Scanner.Job.MeterPipeLength = Me.txtMeterPipeLength
    Scanner.Job.MeterPipeInternalDiameter = Me.txtMeterPipeInternalDiameter
    Scanner.Job.CalculatedByCompany = Me.txtCalculatedByCompany
        
    JobData.SetJobData
    
    
End Sub

Private Sub txtLeadN_Change()

End Sub

Private Sub UserForm_Activate()
    LoadJobData
End Sub

Private Sub UserForm_Initialize()
    LoadJobData
    LoadCalculatedByCompanies
End Sub
Public Sub LoadJobData()

    JobData.ScanJobData
    
    If Scanner.Job Is Nothing Then
        Set Scanner.Job = New Job
    Else
        Me.txtJobName = Scanner.Job.JobName
        Me.txtSiteLocation = Scanner.Job.SiteLocation
        Me.txtLeadN = Scanner.Job.LeadN
        Me.txtStaticPressure = Scanner.Job.StaticPressure
        Me.txtResidualPressure = Scanner.Job.ResidualPressure
        Me.txtAvailableFlow = Scanner.Job.AvailableFlow
        Me.txtMeterElevation = Scanner.Job.MeterElevation
        Me.txtMeterPipeLength = Scanner.Job.MeterPipeLength
        Me.txtMeterPipeInternalDiameter = Scanner.Job.MeterPipeInternalDiameter
        Me.txtCalculatedByCompany = Scanner.Job.CalculatedByCompany
    End If
    
End Sub
Public Sub LoadCalculatedByCompanies()
    Me.txtCalculatedByCompany.Clear
    Me.txtCalculatedByCompany.AddItem "X-Fire Security"
    Me.txtCalculatedByCompany.AddItem "13dpex.com"
End Sub
