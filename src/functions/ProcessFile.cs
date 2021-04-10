// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.WebJobs.Extensions.Storage;
using System.IO;
using System.Data.SqlClient;
using Dapper;
using Newtonsoft.Json;
using System.Threading.Tasks;

namespace Contoso
{
    public class ProcessFile
    {
        [FunctionName("ProcessFile")]
        public async Task Run([EventGridTrigger]EventGridEvent eventGridEvent, 
                               [Blob("{data.url}",FileAccess.Read,Connection = "StrCnx")] Stream input,
                               ILogger log)
        {

            log.LogInformation(eventGridEvent.Data.ToString());

            try
            {
                var blob = JsonConvert.DeserializeObject<Blob>(eventGridEvent.Data.ToString());

                using (var conn = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
                {
                    await conn.OpenAsync();

                    await conn.ExecuteAsync("INSERT INTO log (FileLenght, Url, EventTime) VALUES (@ContentLength,@Url,@EventTime)",
                    new 
                    {
                        blob.ContentLength,
                        blob.Url,
                        eventGridEvent.EventTime
                    });
                }                
            }
            catch (System.Exception ex)
            {
                log.LogError(ex.Message,ex);
                throw;
            }            
        }
    }
}
