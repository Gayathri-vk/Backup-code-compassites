using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using JWT;
using JWT.Serializers;
using System.IdentityModel.Tokens.Jwt;
using Newtonsoft.Json.Linq;
using System.Xml;
using System.IdentityModel.Claims;
using System.Text;
using System.Web;

namespace CNMSWebAPI.Controllers
{
    public class MenuController : ApiController
    {
        string message = "";
        Boolean status = true;
        int clientid = 0;
        Int64 userid = 0;
        HttpContext httpContext = HttpContext.Current;

        public HttpResponseMessage Get()
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;

                try
                {

                    GetTokenClientId();

                }
                catch (TokenExpiredException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
                }
                catch (SignatureVerificationException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);

                }

                string ClientCode = "";
                var session = System.Web.HttpContext.Current.Session;
                if (session != null)
                {
                    if (session["ClientCode"] != null)
                        ClientCode = session["ClientCode"].ToString();
                }
                if (clientid == 0)
                {
                    var dat = (from c in ent.UserRoleMenus
                               join m in ent.MenuDetails on c.MID equals m.MID
                               join r in ent.UserRoles on c.User_RoleId equals r.User_RoleId
                               select new
                               {
                                   c.User_RoleId,
                                   c.MID,
                                   c.UID,
                                   m.Formname,
                                   c.UserRole,
                                   m.RouteName,
                                   r.Role_Name,
                                   c.ClientId,
                                   c.CompanyId,
                                   c.Status,
                                   c.Company.CompanyName,
                                   c.Client.ClientName
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
                else
                {
                    var dat = (from c in ent.UserRoleMenus
                               join m in ent.MenuDetails on c.MID equals m.MID
                               join r in ent.UserRoles on c.User_RoleId equals r.User_RoleId
                               where c.ClientId == clientid
                               select new
                               {
                                   c.User_RoleId,
                                   c.MID,
                                   c.UID,
                                   m.Formname,
                                   c.UserRole,
                                   m.RouteName,
                                   r.Role_Name,
                                   c.ClientId,
                                   c.CompanyId,
                                   c.Status,
                                   c.Company.CompanyName,
                                   c.Client.ClientName
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }

            }
        }
        private void GetTokenClientId()
        {

            string authHeader = this.httpContext.Request.Headers["Authorization"];

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
                    clientid = Convert.ToInt32(spli);

                    string val1 = cli[3].ToString().Replace("[", "").Replace("]", "");
                    string spli1 = val1.Split(',')[1];
                    userid = Convert.ToInt32(spli1);
                }


            }

        }

        public class Menu
        {
            
            public string name { get; set; }
            public string route { get; set; }
            public int role { get; set; }


        }
        public class ResponseModel
        {
            public string main { set; get; }
            public string route { set; get; }
            public int role { get; set; }
            public object list { set; get; }
        }
        public HttpResponseMessage Get(int id)
        {
            try
            {

                GetTokenClientId();

            }
            catch (TokenExpiredException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            catch (SignatureVerificationException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);

            }
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                if (id != 0)
                {
                    List<ResponseModel> ResponseModelList = new List<ResponseModel>();
                    if (id == 1 || id == 8)
                    {
                        if (id == 1)
                        {
                            var meu = (from m in ent.MenuDetails
                                           //where m.ParentId == null 
                                       where m.MID == 1
                                       select new { m.MID, route = m.RouteName, main = m.Formname, role = 0 }).Distinct().ToList();


                            foreach (var item1 in meu)
                            {
                                List<Menu> MenuList = new List<Menu>();

                                var dat = (from m in ent.MenuDetails
                                           where m.ParentId == item1.MID && m.MID!= 20 && m.MID != 23
                                           select new { route = m.RouteName, name = m.Formname, role = 0 }).ToList();
                                if (dat != null)
                                {
                                    foreach (var item in dat)
                                    {
                                        Menu m = new Menu();
                                        m.name = item.name;
                                        m.route = item.route;
                                        m.role = item.role;
                                        MenuList.Add(m);

                                    }
                                    ResponseModel _objResponseModel = new ResponseModel();
                                    _objResponseModel.main = item1.main;
                                    _objResponseModel.route = item1.route;
                                    _objResponseModel.role = item1.role;
                                    _objResponseModel.list = MenuList;
                                    ResponseModelList.Add(_objResponseModel);


                                }
                            }
                            return Request.CreateResponse(HttpStatusCode.OK, ResponseModelList);
                        }
                        else
                        {
                            var meu = (from m in ent.MenuDetails
                                       where m.ParentId == null && m.MID == 1
                                       select new { m.MID, route = m.RouteName, main = m.Formname, role = 0 }).Distinct().ToList();


                            foreach (var item1 in meu)
                            {
                                List<Menu> MenuList = new List<Menu>();

                                var dat = (from m in ent.MenuDetails
                                           where m.ParentId == item1.MID && m.MID == 5
                                           select new { route = m.RouteName, name = m.Formname, role = 0 }).ToList();
                                if (dat != null)
                                {
                                    foreach (var item in dat)
                                    {
                                        Menu m = new Menu();
                                        m.name = item.name;
                                        m.route = item.route;
                                        m.role = item.role;
                                        MenuList.Add(m);

                                    }
                                    ResponseModel _objResponseModel = new ResponseModel();
                                    _objResponseModel.main = item1.main;
                                    _objResponseModel.route = item1.route;
                                    _objResponseModel.role = item1.role;
                                    _objResponseModel.list = MenuList;
                                    ResponseModelList.Add(_objResponseModel);


                                }
                            }
                            return Request.CreateResponse(HttpStatusCode.OK, ResponseModelList);
                        }
                    }
                    else
                    {
                        Int64 sf = userid;
                        var meu = (from c in ent.UserRoleMenus
                                   join m in ent.MenuDetails on c.MID equals m.MID
                                   where c.User_RoleId == id && m.ParentId == null && c.ClientId == clientid
                                   select new { m.MID, route = m.RouteName, main = m.Formname, role = c.User_RoleId }).Distinct().ToList();

                        int chp = 0;
                        int chp1 = 0;
                        foreach (var item1 in meu)
                        {
                            List<Menu> MenuList = new List<Menu>();

                            var dat = (from c in ent.UserRoleMenus
                                       join m in ent.MenuDetails on c.MID equals m.MID
                                       where c.User_RoleId == id && m.ParentId == item1.MID && c.ClientId == clientid
                                       orderby m.MID
                                       select new { route = m.RouteName, name = m.Formname, role = c.User_RoleId, m.ParentId }).ToList();
                            if (dat != null)
                            {
                                foreach (var item in dat)
                                {
                                    Menu m = new Menu();
                                    m.name = item.name;
                                    m.route = item.route;
                                    m.role = item.role;

                                    var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                                    if (dbt != null)
                                    {

                                        using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                                        {
                                            connection.Open();
                                            DataTable dt1 = new DataTable();
                                            if (item.ParentId == 1)
                                            {
                                                MenuList.Add(m);

                                            }
                                            if (item.ParentId == 15)
                                            {
                                                MenuList.Add(m);

                                            }
                                            if (m.name == "Import BOQ")
                                            {
                                                MenuList.Add(m);
                                            }
                                            if (m.name == "Project Name & Duration")
                                            {
                                                dt1 = new DataTable();
                                                SqlDataAdapter da = new SqlDataAdapter("select * from ProjectMaster p where ClientId=" + clientid, connection);
                                                da.Fill(dt1);
                                                if (dt1.Rows.Count > 0)
                                                {
                                                    chp1 = 1;
                                                }
                                                MenuList.Add(m);


                                            }
                                            if (chp1 == 1)
                                            {
                                                if (m.name == "Project Description")
                                                {
                                                    dt1 = new DataTable();
                                                    SqlDataAdapter da = new SqlDataAdapter("select * from ProjectDescription pd join ProjectMaster p on p.ProjectId=pd.ProjectId where ClientId=" + clientid, connection);
                                                    da.Fill(dt1);
                                                    MenuList.Add(m);
                                                    if (dt1.Rows.Count > 0)
                                                    {
                                                        chp = 1;
                                                    }
                                                    else
                                                         continue;

                                                }
                                                if (chp == 1)
                                                {
                                                    if (m.name == "Bill of Quantities")
                                                    {
                                                        dt1 = new DataTable();
                                                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails pd join ProjectMaster p on p.ProjectId=pd.ProjectId where BOQType='P' and p.ClientId=" + clientid, connection);
                                                        da.Fill(dt1);
                                                        MenuList.Add(m);
                                                        if (dt1.Rows.Count > 0)
                                                            chp = 2;
                                                        else
                                                             continue;
                                                    }
                                                }
                                                if (chp == 2)
                                                {
                                                    if (m.name == "BOQ View")
                                                        MenuList.Add(m);
                                                    //        chp = 3;
                                                    //}
                                                    //    if (chp == 3)
                                                    //    {
                                                    if (m.name == "BOQ Daily Workdone %")
                                                    {
                                                        dt1 = new DataTable();
                                                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqDailyProcess b join BoqEntryDetails pd on b.BOQId=pd.BOQId join ProjectMaster p on p.ProjectId=pd.ProjectId where p.ClientId=" + clientid, connection);
                                                        da.Fill(dt1);
                                                        MenuList.Add(m);
                                                        if (dt1.Rows.Count > 0)
                                                            chp = 2;
                                                        else
                                                            continue;
                                                    }
                                                    //}
                                                    //if (chp == 4)
                                                    //{
                                                    if (m.name == "BOQ Variation")
                                                    {
                                                        dt1 = new DataTable();
                                                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails pd join ProjectMaster p on p.ProjectId=pd.ProjectId where BOQType='V' and p.ClientId=" + clientid, connection);
                                                        da.Fill(dt1);
                                                        MenuList.Add(m);
                                                        if (dt1.Rows.Count > 0)
                                                            chp = 2;
                                                        else
                                                             continue;
                                                    }
                                                    //}
                                                    //if (chp == 5)
                                                    //{
                                                    if (m.name == "BOQ Schedule Revisions")
                                                    {
                                                        dt1 = new DataTable();
                                                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqReviseDetails b join BoqEntryDetails pd on b.BOQId=pd.BOQId join ProjectMaster p on p.ProjectId=pd.ProjectId where p.ClientId=" + clientid, connection);
                                                        da.Fill(dt1);
                                                        MenuList.Add(m);
                                                        if (dt1.Rows.Count > 0)
                                                            chp = 2;
                                                        else
                                                             continue;
                                                    }
                                                    //}
                                                    //if (chp == 6)
                                                    //{

                                                    if (m.name == "BOQ Base Schedule")
                                                    {
                                                        dt1 = new DataTable();
                                                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails pd join ProjectMaster p on p.ProjectId=pd.ProjectId where BOQType='V' and p.ClientId=" + clientid, connection);
                                                        da.Fill(dt1);
                                                        MenuList.Add(m);
                                                        if (dt1.Rows.Count > 0)
                                                            chp = 2;
                                                        else
                                                             continue;
                                                    }

                                                    //if (m.name == "BOQ Revise New")
                                                    //    MenuList.Add(m);

                                                    if (m.name == "BOQ Schedule Dates View")
                                                        MenuList.Add(m);
                                                    chp = 2;
                                                }

                                            }
                                            connection.Close();
                                        }

                                    }
                                    //                                    MenuList.Add(m);

                                }
                                ResponseModel _objResponseModel = new ResponseModel();
                                _objResponseModel.main = item1.main;
                                _objResponseModel.route = item1.route;
                                _objResponseModel.role = item1.role;
                                _objResponseModel.list = MenuList;
                                ResponseModelList.Add(_objResponseModel);


                            }


                        }
                        return Request.CreateResponse(HttpStatusCode.OK, ResponseModelList);


                    }
                }
                else
                {
                    var dat = ent.MenuDetails.Where(a => a.Status == 1).ToList();
                    if (dat != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, dat);

                    }
                    else
                    {
                        message = "MenuDetails does not found";
                        return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                    }
                }
            }
        }


            [HttpGet]
        public HttpResponseMessage Get(int id, int val)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                message = "";
                ent.Configuration.ProxyCreationEnabled = false;
                var dat2 = ent.UserRoleMenus.FirstOrDefault(c => c.UID == id);
                if (dat2 != null)
                {
                    
                        ent.UserRoleMenus.RemoveRange
                        (ent.UserRoleMenus.Where(r => r.UID == id));
                    ent.SaveChanges();
                        message = "Deleted Successfully";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    
                }
                else
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
            }
        }
        public class midList
        {
            public long MID { get; set; }
        }
        public partial class UserRoleMenuList
        {
            public long UID { get; set; }
            public int CompanyId { get; set; }
            public Nullable<long> ClientId { get; set; }
            public int User_RoleId { get; set; }
            public List<int> MID { get; set; }

            //public long MID { get; set; }
            //public List<midList> MID { get; set; }
            public Nullable<int> Status { get; set; }

            public virtual Client Client { get; set; }
            public virtual Company Company { get; set; }
            public virtual MenuDetail MenuDetail { get; set; }
            public virtual UserRole UserRole { get; set; }
        }
        public HttpResponseMessage Post([FromBody] UserRoleMenuList UserMeu)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    //var dat2 = ent.UserRoleMenus.FirstOrDefault(c => c.UID == UserMeu.UID);
                    //if (dat2 == null)
                    //{
                        foreach (var Fitem in UserMeu.MID)
                        {
                        
                            var dat = ent.UserRoleMenus.FirstOrDefault(c => c.ClientId == UserMeu.ClientId && c.User_RoleId == UserMeu.User_RoleId && c.MID == Fitem);
                            if (dat == null)
                            {
                                UserRoleMenu un = new UserRoleMenu();
                                un.ClientId = UserMeu.ClientId;
                                un.CompanyId = UserMeu.CompanyId;
                                un.MID = Fitem;
                                un.Status = 1;
                                un.User_RoleId = UserMeu.User_RoleId;

                                ent.UserRoleMenus.Add(un);
                                ent.SaveChanges();
                                message = "Saved Successfully";
                                // return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }

                            //else
                            //{
                            //    status = false;
                            //    message = "UserRole Menu already exists";
                            //  return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //}
                            //}
                            //else
                            //{
                            //    var dat1 = ent.UserRoleMenus.FirstOrDefault(c => c.ClientId == UserMeu.ClientId && c.User_RoleId == UserMeu.User_RoleId && c.MID == Fitem.MID);

                            //    var dat = ent.UserRoleMenus.FirstOrDefault(c => c.UID == UserMeu.UID);
                            //    if (dat1 == null)
                            //    {
                            //        if (dat != null)
                            //        {
                            //            dat.MID = Fitem.MID;
                            //            dat.ClientId = UserMeu.ClientId;
                            //            dat.User_RoleId = UserMeu.User_RoleId;
                            //            dat.Status = UserMeu.Status;
                            //            ent.SaveChanges();

                            //            message = "Updated Successfully";
                            //         //   return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //}
                            //else
                            //{

                            //    message = "UserRole Menu with id = " + UserMeu.UID.ToString() + " not found";
                            //   return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                            //        }
                            //    }
                            //    else
                            //    {
                            //        if (dat.UID != dat.UID)
                            //        {
                            //            status = false;
                            //            message = "UserRole Menu already exists";
                            //          //  return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //        }
                            //        else
                            //        {
                            //            dat.MID = Fitem.MID;
                            //            dat.ClientId = UserMeu.ClientId;
                            //            dat.User_RoleId = UserMeu.User_RoleId;
                            //            dat.Status = UserMeu.Status;
                            //            ent.SaveChanges();


                            //            message = "Updated Successfully";
                            //          //  return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //        }
                            //    }
                            //}


                            
                        }
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    

                //}
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }
}
