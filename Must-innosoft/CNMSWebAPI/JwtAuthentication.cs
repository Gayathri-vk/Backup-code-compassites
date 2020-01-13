using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;

namespace CNMSWebAPI.Models
{
    public class JwtAuthentication
    {
        public const string Secret = "db3OIsj+BXE9NZDy0t8W3TcNekrF+2d/1sFnWG4HnV8TZY30iTOdtVWJG8abWvB1GlOgJuQZdcF2Luqm/hccMw==";

        

        public static string GenerateToken(string username, long clientid,int userrole, int expireMinutes = 20)
        {
            var symmetricKey = Convert.FromBase64String(Secret);
            var tokenHandler = new JwtSecurityTokenHandler();
            
            var now = DateTime.UtcNow;
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                        {
                            new Claim(ClaimTypes.Name, username,clientid.ToString(),userrole.ToString())
                        }),

                Expires = now.AddMinutes(Convert.ToInt32(expireMinutes)),

                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(symmetricKey), SecurityAlgorithms.HmacSha256Signature)
                

        };

            var stoken = tokenHandler.CreateToken(tokenDescriptor);
            var token = tokenHandler.WriteToken(stoken);

            return token;
        }

        public static ClaimsPrincipal GetPrincipal(string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var jwtToken = tokenHandler.ReadToken(token) as JwtSecurityToken;

                if (jwtToken == null)
                    return null;

                var symmetricKey = Convert.FromBase64String(Secret);

                var validationParameters = new TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(symmetricKey)
                };

                SecurityToken securityToken;
                var principal = tokenHandler.ValidateToken(token, validationParameters, out securityToken);

                return principal;
            }

            catch (Exception)
            {
                return null;
            }
        }

        public static string GetTokenClientId(string authHeader)
        {
            

            
            var clientid = "0";

            try { 

            var authBits = authHeader.Split(' ');

                

                var tokenHandler = new JwtSecurityTokenHandler();

            var readableToken = tokenHandler.CanReadToken(authBits[1].ToString());
            if (readableToken == true)
            {

                   

                var jwtToken = tokenHandler.ReadToken(authBits[1]) as JwtSecurityToken;
                    
                    var cli = jwtToken.Payload.ToList();
                if (cli.Count > 0)
                {
                    string val = cli[2].ToString().Replace("[", "").Replace("]", "");
                    string spli = val.Split(',')[1];
                        clientid = spli;

                        //string val1 = cli[4].ToString().Replace("[", "").Replace("]", "");
                        //string spli1 = val1.Split(',')[1];
                        //DateTime ssd = Convert.ToDateTime(spli1);
                        //DateTime today1 = DateTime.Now; 
                        //TimeSpan difference1 = Convert.ToDateTime(today1) - ssd;

                        //var days1 = Math.Round(difference1.TotalMinutes, 0) + 1;
                        //if (2 >= days1)
                        //{

                        //}
                        //else
                        //{                            
                        //    Controllers.UserLoginController hc = new Controllers.UserLoginController();
                        //    hc.Get();
                        //}
                    }


                }

                return clientid;
            }

            catch (Exception)
            {
                return null;
            }
        }
        public static string GetTokenUserId(string authHeader)
        {
            var userId = "0";
            


            try
            {

                var authBits = authHeader.Split(' ');
                var tokenHandler = new JwtSecurityTokenHandler();

                var readableToken = tokenHandler.CanReadToken(authBits[1].ToString());
                if (readableToken == true)
                {
                    var jwtToken = tokenHandler.ReadToken(authBits[1]) as JwtSecurityToken;

                    var cli = jwtToken.Payload.ToList();
                    if (cli.Count > 0)
                    {
                        string val = cli[3].ToString().Replace("[", "").Replace("]", "");
                        string spli = val.Split(',')[1];
                        userId = spli;

                        
                    }


                }

                return  userId ;
            }

            catch (Exception)
            {
                return null;
            }
        }
    }
}