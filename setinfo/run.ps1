using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$connectionString = "Server=tcp:skyworkz-sqlserver.database.windows.net,1433;Initial Catalog=skyworkz-sql;Persist Security Info=False;User ID=sqladmin;Password=kiloploki323!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$query = "INSERT example VALUES (@name, @lastname);"

try 
{
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.Parameters.AddWithValue("@name", $Request.Body.name); 
    $command.Parameters.AddWithValue("@lastname", $Request.Body.lastname);

    $result = $command.ExecuteReader();
    $status = [HttpStatusCode]::OK
}
catch 
{
    Write-Error -Message $_.Exception
    throw $_.Exception
    $status = [HttpStatusCode]::Unauthorized
}

$connection.Close()

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = "Data inserted correctly"
})
