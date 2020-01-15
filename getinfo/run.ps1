using namespace System.Net

param($Request, $TriggerMetadata)

$connectionString = "Server=tcp:skyworkz-sqlserver.database.windows.net,1433;Initial Catalog=skyworkz-sql;Persist Security Info=False;User ID=sqladmin;Password=kiloploki323!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$query = "SELECT * FROM example;"

try 
{
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString

    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    $result = $command.ExecuteReader();

    $table = new-object "System.Data.DataTable"
    $table.Load($result)
    $body = $table | Select-Object $table.Columns.ColumnName | ConvertTo-Json

    $status = [HttpStatusCode]::OK
    $connection.Close()
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
    $status = [HttpStatusCode]::Unauthorized
}

$connection.Close()

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
