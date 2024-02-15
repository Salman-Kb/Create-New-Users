Import-Module ActiveDirectory

$Users = Import-Csv "C:\Users\user\Desktop\NewUsers.csv"
$Messages = @()

foreach ($User in $Users) {
    $ID = $User.EmployeeID
    $Firstname = $User.First
    $Lastname = $User.Last
    $DisplayName = $User.DisplayName
    $UserName = $User.UserName
    $Email = $User.Email
    $Department = $User.Dept
    $JobTitle = $User.Title
    $Phone = $User.Phone
    $City = $User.City
    $StreetAddress = $User.Address
    $Password = $User.Password
    $OU = $User.OU

    if (Get-ADUser -Filter {SamAccountName -eq $UserName}) {
        $Message = "The user '$UserName' already exists."
        $Messages += [PSCustomObject]@{
            UserName = $UserName
            Message = $Message
        }
    } else {
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

        New-ADUser -EmployeeID $ID `
            -GivenName $Firstname `
            -Surname $Lastname `
            -DisplayName $DisplayName `
            -Name $UserName `
            -SamAccountName $UserName `
            -UserPrincipalName "$UserName@qwerty.com" `
            -EmailAddress $Email `
            -Department $Department `
            -Title $JobTitle `
            -OfficePhone $Phone `
            -City $City `
            -StreetAddress $StreetAddress `
            -Path $OU `
            -AccountPassword $SecurePassword `
            -ChangePasswordAtLogon $True `
            -Enabled $True

        $Message = "User '$UserName' created successfully."
        $Messages += [PSCustomObject]@{
            UserName = $UserName
            Message = $Message
        }
    }
}

$Messages | Export-Csv -Path "C:\Users\user\Desktop\Output.csv" -NoTypeInformation
