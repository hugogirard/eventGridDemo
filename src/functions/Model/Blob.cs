using Newtonsoft.Json;

namespace Contoso
{
    public class Blob 
    {
        [JsonProperty("contentLength")]
        public string ContentLength { get; set; }

        [JsonProperty("url")]
        public string Url { get; set; }
    }
}