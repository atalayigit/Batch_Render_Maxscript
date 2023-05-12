macroScript Quick
category:"Atalay Script"
tooltip:"Atalay"
buttontext:"Render_quick"
 (
   dotNet.loadAssembly "MaxCustomControls.dll"
   local filetoprint = ""
   local printFont = dotnetobject "System.Drawing.Font" "Arial" 10
   local filetoprint1 = ""
   local filetoprintarr = #()
	local  trs =#()
   hForm = dotNetObject "MaxCustomControls.MaxForm"
   hForm.Size = dotNetObject "System.Drawing.Size" 640 480
   hForm.FormBorderStyle = (dotnetclass "System.Windows.Forms.FormBorderStyle").FixedToolWindow
   hForm.Text = "RENDER Machine"
   hForm.ShowInTaskbar = False
	

   listbox1 = dotNetObject "System.Windows.Forms.ListBox"
   listbox1.Location = dotNetObject "System.Drawing.Point" 0 10
   listbox1.Size = dotNetObject "System.Drawing.Size" 500 430
   listbox1.ItemHeight = 30
	

   btnOpenFile = dotNetObject "System.Windows.Forms.Button"
   btnOpenFile.Location = dotNetObject "System.Drawing.Point" 520 10
   btnOpenFile.Text = "Add"
   btnOpenFile.Height=50


   btnDelete = dotNetObject "System.Windows.Forms.Button"
   btnDelete.Location = dotNetObject "System.Drawing.Point" 520 100
   btnDelete.Text = "Delete"
   btnDelete.Height=50
   
   btnRender = dotNetObject "System.Windows.Forms.Button"
   btnRender.Location = dotNetObject "System.Drawing.Point" 520 300
   btnRender.Text = "Render"
   btnRender.Height=75
   btnRender.FlatAppearance.BorderSize=0
   btnRender.FlatStyle.value__ =3
   
   txt_created = dotNetObject "System.Windows.Forms.LinkLabel"
   txt_created.Location = dotNetObject "System.Drawing.Point" 520 180
   txt_created.Text = "Yigit Atalay"
   txt_created.Links.Add 0 12 "https://www.linkedin.com/in/yigitatalay/" 

   frmOpenFileDialog = dotNetObject "System.Windows.Forms.OpenFileDialog"
   frmOpenFileDialog.Filter = "3ds Max (.max)|*.max"
   frmOpenFileDialog.Multiselect=True
   
   fn btnOpenFile_Click_yedek = (
     dlgResult = dotNetClass "System.Windows.Forms.DialogResult"
     if frmOpenFileDialog.ShowDialog() == dlgResult.OK then (
	   for f in frmOpenFileDialog.fileNames  do (
		   if listbox1.Items.Contains f then(
			   messageBox "Eklenecekler arasinda bir dosya zaten ekli"
			   )else (
			   
			   listbox1.Items.Add f
			   )
		   
		   )
	   )--end if
	 
   )--end fn
   
	-- Removes Object fromt list
	fn btnDelete_Click=
	(
			if listbox1.SelectedItem!="" then(
			local currSel = listbox1.SelectedItem
			listbox1.Items.Remove currSel
			listbox1.Refresh()
			listbox1.Update()
			)
	)


fn btnOpenFile_Click1 = (
	trs=#()
	 --listbox1.Items.Clear()
	
	-- filetoprintarr = #()
	-- listbox1.Items.AddRange filetoprintarr
	--listbox1.Refresh()
	--listbox1.Update()
	 --messageBox "No valid filessa."
	--trs =listbox1.Items.Item[0]
		for t=1 to listbox1.Items.Count do(
			
			append trs listbox1.Items.Item[t-1]
		)
		messageBox trs
	 	
   )--end fn
   
   fn btnRenderClick=(
	   
	filesArr = #()
			
		--	for f in listbox1.Items where (doesFileExist f) do appendIfUnique filesArr f			
			for t=1 to listbox1.Items.Count where (doesFileExist listbox1.Items.Item[t-1])do(
			
			append filesArr listbox1.Items.Item[t-1]
		)

			totalFiles = filesArr.count
			
			if totalFiles > 0 then (
				
				prevQuietMode = GetQuietMode()
			--	noWarning = chbIgnoreWarnings.state
				--SetQuietMode noWarning
			
				for n=1 to totalFiles do (
					
					if keyboard.escPressed then exit
					
					loadMaxFile filesArr[n] useFileUnits:true quiet:false
					
					-- Render only the first frame
					
					-- Set width and height
					renderWidth = int (ceil (renderWidth*100.0/100.0))
					renderHeight = int (ceil (renderHeight*100.0/100.0))
					
					try (					
						max quick render
					) catch (
						messageBox (getCurrentException())
						exit
					)
				)
				
				SetQuietMode prevQuietMode
				
			) else messageBox "No valid files."				
	)
   dotNet.AddEventHandler btnOpenFile "Click" btnOpenFile_Click_yedek
   dotNet.AddEventHandler btnDelete "Click" btnDelete_Click
  --dotNet.AddEventHandler listbox1 "MouseDoubleClick" btnOpenFile_Click1
   dotNet.AddEventHandler btnRender "Click" btnRenderClick
	
   hForm.Controls.Add(btnOpenFile)
   hForm.Controls.Add(btnDelete)
   hForm.Controls.Add(listbox1)
   hForm.Controls.Add(txt_created)
   hForm.Controls.Add(btnRender)
   
   
   dotnet.setLifetimeControl btnOpenFile #dotnet
   dotnet.setLifetimeControl btnDelete #dotnet
   dotnet.setLifetimeControl listbox1 #dotnet
   dotnet.setLifetimeControl txt_created #dotnet
   dotnet.setLifetimeControl btnRender #dotnet
   
   
   hForm.ShowModeless()
   )