using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$connectionString = "Server=tcp:sw-exam-sqlserver.database.windows.net,1433;Initial Catalog=sw-exam-database;Persist Security Info=False;User ID=sqladmin;Password=XXXXXXX;MultipleActiveResultSets=true;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$query = "INSERT example VALUES (@name, @lastname);"

try 
{
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
   
    $elements = $Request.Body

    for ($i=0;$i -lt $elements.count;$i++)
    {
        $command = $connection.CreateCommand()
        $command.CommandText = $query
        $command.Parameters.AddWithValue("@name", $elements[$i].name); 
        $command.Parameters.AddWithValue("@lastname", $elements[$i].lastname);
    
        $command.ExecuteReader();     
    }

    $status = [HttpStatusCode]::OK
    $connection.Close()
}
catch 
{
    Write-Error -Message $_.Exception
    throw $_.Exception
    $status = [HttpStatusCode]::Unauthorized
}



Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = "Data inserted correctly"
})
