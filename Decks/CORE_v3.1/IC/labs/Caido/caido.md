![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Caido

## Lab Goal

The goal of this lab is to introduce Caido and its core web application security testing features. The lab uses the free Caido Basic plan and Damn Vulnerable Web Application (DVWA) as the testing target.

## In this lab you will

- Launch Caido and create a new instance and project
- Configure browser traffic to pass through Caido and explore endpoints using Sitemap
- Create and apply a scope for the target application
- Use HTTPQL filters to organize captured traffic
- Intercept, inspect, modify, and manage HTTP requests
- Review captured traffic through HTTP History
- Create rules to automatically modify matching requests and use Replay to resend and compare them
- Upload wordlists and automate parameter testing and brute-force attempts
- Use Automate to test multiple payloads and perform a controlled brute-force test.
- Create a simple workflow to process selected requests, apply actions, and streamline analysis

## What is Caido

Caido is a web application security testing toolkit designed to help security professionals inspect, modify, replay, and automate HTTP and WebSocket traffic.

Its main component is an intercepting proxy that operates between a client, such as a web browser, and a web server. Caido can capture requests before they reach the server and responses before they return to the client. The tester can then inspect or modify this traffic and observe how the application behaves.

Caido provides several interfaces for organizing and analyzing web traffic, including HTTP History, Sitemap, Intercept, Replay, Automate, Match & Replace, and Workflows. These features help testers understand how an application communicates and investigate potential security vulnerabilities.


## Launch DVWA

First of all, we will launch our target site. Navigate in the lab's directory and launch DVWA.

```bash
cd ~/BnB/Caido/DVWA
sudo docker compose up -d
```

![image](./attachments/img01.png)

After launching it, verify that it is running.

```bash
sudo docker ps
```

![image](./attachments/img02.png)

Now, where DVWA is running, access it through the browser using the following address: `http://dvwa.com:4280`.

>[!NOTE]
>
>We added the `dvwa.com` entry to the `/etc/hosts` file because browsers often bypass configured proxies when accessing `localhost` or other loopback addresses directly. As a result, the traffic would not pass through Caido and would not be captured.

![image](./attachments/img03.png)

Log in with the following credentials:

- **Username**: `admin`
- **Password**: `password`

![image](./attachments/img04.png)

Then scroll down and press the `Create/Reset Database` button to create the DVWA database.

![image](./attachments/img05.png)

After the database creation, we have to log in again. Use the same credentials as above.

![image](./attachments/img06.png)

We have now completed DVWA configuration.

![image](./attachments/img07.png)

## Launch Caido

Press the search icon in the Ubuntu menu and write **Caido**.

![image](./attachments/img08.png)

![image](./attachments/img09.png)

Press enter to launch it.

## Instances

After launching Caido, the first thing we see is the Instances interface. A Caido **Instance** is a workspace where your testing data, settings, and captured traffic are stored. Each instance is tied to an account, keeping your data secure and separate. You can name instances to match specific projects or targets.

As we can see, by default Caido already has an instance created, called **Local instance**.

![image](./attachments/img10.png)

We will delete the default one and create a new one. To delete an instance, press the three dots next to it and then delete.

![image](./attachments/img11.png)

![image](./attachments/img12.png)

Let's create a new instance. Press the **New Instance** button at the top right.

![image](./attachments/img13.png)

In this tab, we can configure our new instance.

![image](./attachments/img14.png)

Two instance types exist: `Local` and `Remote`. **Local** are the instances running on our computer. **Remote** are the instances running on a remote server that we access through the network. For this lab, we will create a local instance.

Fill in the following fields as defined below:

- **Name**: Caido Lab
- **Listening address**: Leave the default value
- **Listening port**: 8081

Let everything else be as it is and press `Create`.

![image](./attachments/img15.png)

![image](./attachments/img16.png)

We now have our instance created.

![image](./attachments/img17.png)

Press `Start` to access the instance.

![image](./attachments/img18.png)

We will then be taken to a page that asks us to log in to our account. Press **Continue as guest**.

![image](./attachments/img19.png)

We can now access the Caido interface.

![image](./attachments/img20.png)

-----

Caido organizes its tools into five collapsible sections in the left navigation sidebar:

- Overview
- Proxy
- Testing
- Logging
- Workspace

Each section contains tools related to a specific part of the testing process.

## Workspace Section

### Workspace

When we first access the Caido interface, the **Workspace** interface is displayed.

![image](./attachments/img21.png)

From this window, we can:

1. Create a new project
2. Import an existing project
3. View all created projects in a list. In our case, the list is empty because we have not created a project yet

![image](./attachments/img22.png)

To continue, we need to create a project. Press the **Create a project** button in the top right corner.

![image](./attachments/img23.png)

We can now specify a name for the project. Enter `DVWA`. Because we are using Caido as a guest, the **Mark as temporary** option is automatically enabled and cannot be disabled. This means that the project will not be stored permanently. Press **Create** to create the project.

![image](./attachments/img24.png)

We can now see our new project and information about it, such as its version, size, and the creation/update dates.

![image](./attachments/img25.png)

By clicking the three dots next to the project, we can rename it, copy its path, create a backup, or delete it.

![image](./attachments/img26.png)

In the top right corner, we can select the project we want to work on.

![image](./attachments/img27.png)

### Files

On the **Files** interface, we can upload files, such as wordlists, and make them available for use within the Caido instance.

To upload a file, press the **Upload** button in the top-right corner and select the desired file from your computer.

![image](./attachments/img28.png)

### Plugins

On the **Plugins** interface, we can install plugins that extend Caido's functionality. The **Official** tab contains plugins published by the Caido development team, while the **Community** tab contains plugins created by members of the Caido community. Because community plugins execute third-party code, Caido warns that they may introduce security risks. We can see the installed plugins under the **Installed** tab.

![image](./attachments/img29.png)

![image](./attachments/img30.png)

![image](./attachments/img31.png)

## Certificate Setup

Before moving on, we will import Caido's CA certificate into Firefox. This allows the browser to trust the certificates generated by Caido when intercepting HTTPS traffic.

> [!NOTE]
>
>If the target application uses plain HTTP, like DVWA in this lab, the certificate is not strictly required. However, importing it is a good practice because it allows Caido to properly intercept and inspect HTTPS traffic as well.

**Every Caido instance has its own CA certificate. Therefore, if we are working with multiple instances, we have to import the different certificates into the browser as well.**

Click the profile icon in the top-right corner and then select `CA Certificate`.

![image](./attachments/img32.png)

![image](./attachments/img33.png)

Then select **Linux** as the platform and **Firefox** as the browser, and download the certificate.

![image](./attachments/img34.png)

Open Firefox, press the three-line menu button in the top-right corner, and go to **Settings**.

![image](./attachments/img35.png)

In the settings search bar, search for `certificates` and select **Advanced Settings**.

![image](./attachments/img36.png)

Then scroll down to the **Certificates** section and press **Manage Certificates**.

![image](./attachments/manage_cert.png)

Select the **Import** button and navigate to the directory where the certificate was downloaded, usually the `Downloads` directory. Select the certificate file and press **Select** to import it.

![image](./attachments/img37.png)

![image](./attachments/img38.png)

Select the certificate and, when prompted, enable the option to trust this CA to identify websites.

![image](./attachments/img39.png)

After importing the certificate, select **OK** and restart Firefox.

## Overview Section

### Sitemap

On the **Sitemap** interface, all discovered resources are displayed in a structured view of the application. Caido groups captured requests by domain into directories and endpoints, allowing us to explore the application hierarchy and quickly view request and response details.

For the time being, this window is empty because we have Caido's foxy proxy extension closed.

![image](./attachments/img40.png)

Enable this extension, open the DVWA page (`http://dvwa.com:4280`) and visit the following sites from your browser.

- https://www.blackhillsinfosec.com/
- https://www.antisyphontraining.com/
- https://home.backdoorsandbreaches.com/
- https://app.skillbit.com/

![image](./attachments/img41.png)

![image](./attachments/img42.png)

Return to Caido and observe the **Sitemap** interface.

![image](./attachments/img43.png)

As we can see, the Sitemap contains the websites we visited through the browser. It may also include additional domains that were contacted indirectly, such as domains related to Google Search, advertisements, analytics, telemetry, or other background browser requests.

We can now examine the captured traffic by selecting a domain from the Sitemap and then choosing one of its requests.

Open the **dvwa.com** entry. The requests captured for this domain are displayed in the top panel. When we select a specific request, Caido displays the HTTP request in the bottom-left panel and the corresponding HTTP response in the bottom-right panel.

![image](./attachments/img44.png)

In your browser close all the tabs except the DVWA.

### Scopes

The **Scope** interface allows us to define which targets belong to our testing scope. This is useful when the proxy captures traffic from many different domains, such as background browser requests, search engine requests, advertisements, analytics, or telemetry.

During scope creation, we can specify the target applications in the **In Scope** list and the targets that should be excluded from the test in the **Out of Scope** list.

![image](./attachments/img45.png)

For this lab, we will create a scope for DVWA so that we can focus only on the traffic related to our target application.

Press **New Scope** to create a new scope and fill in the fields with the following values:

- **Name**: `DVWA`
- **In Scope**: `dvwa.com` and `*.dvwa.com`
- **Out of Scope**: Leave it empty

Then press **Save**.

![image](./attachments/img46.png)

![image](./attachments/img47.png)

In the **In Scope** list, we define `dvwa.com` as our target domain. If the application also uses subdomains, we can add the second entry, `*.dvwa.com`, to include all subdomains of `dvwa.com` in the scope.

After creating the scope, go back to the **Sitemap** interface. We can apply the scope from the **Unset Scope** drop-down menu by selecting the `DVWA` scope. Once applied, Caido will focus on the targets that match our defined scope, making it easier to analyze only the traffic that is relevant to the lab.

![image](./attachments/img48.png)

![image](./attachments/img49.png)

We can now focus only on the requests related to our target site.

### Filters

The **Filters** interface allows us to create filter presets that help us include or exclude specific traffic from Caido’s traffic tables and operations.

This is useful when a lot of traffic has been captured and we want to focus only on specific requests, such as requests to a certain host, requests that return a specific status code, or requests that contain specific data.

Filters in Caido are written using **HTTPQL**, which is Caido’s query language for filtering HTTP traffic.

![image](./attachments/img50.png)

Caido by default has two filters that exclude images and styling-related resources. By clicking on them, we can view their HTTPQL queries.

![image](./attachments/img51.png)

We will create a filter that shows only requests where form data is submitted, for example, when we try to log in or perform a command injection.

Press the **New Preset** button and fill in the fields with the following values:

- **Scope**: Project
- **Name**: DVWA Form Submission
- **Alias**: dvwa-form-submission
- **Expression**: `req.host.cont:"dvwa.com" AND (req.method.eq:"POST" OR req.query.cont:"=")`

Then press **Save**.

![image](./attachments/img52.png)

In this section, we created the filter preset. Later, when we analyze the **HTTP History** interface, we will apply this filter to the captured traffic and observe how it helps us focus on specific requests.

## Proxy Section

### Intercept

The **Intercept** interface allows us to pause HTTP traffic before it reaches the web server or before the response returns to the browser. This gives us the ability to inspect, modify, forward, or drop requests and responses.

This is one of the most important features of a web proxy because it allows us to interact with application traffic in real time.

![image](./attachments/img53.png)

To demonstrate this feature, make sure that FoxyProxy is enabled and that the browser traffic is passing through Caido.

In the top bar, we can see a green **Forwarding** button. This means that traffic is not paused by Intercept and is forwarded normally.

![image](./attachments/img54.png)

By clicking on it, the state changes to **Queuing**. At this point, if we generate browser traffic, the requests or responses will be paused by Caido and placed in the queue until we manually forward or drop them.

![image](./attachments/img55.png)

When traffic is queued, we have the ability to inspect, modify, forward, or drop it. We can perform these actions on both requests and responses.

We can choose what we want to intercept by selecting the checkboxes in the **Choose what to intercept** panel. For now, select both **Requests** and **Responses**. Before generating browser traffic, also select the **DVWA** scope we created earlier.

![image](./attachments/img56.png)

Now return to DVWA and click the first four vulnerability buttons, from **Brute Force** to **File Inclusion**. Notice that the page appears to be loading but doesn't change. This happens because the traffic has been paused by Intercept. 

![image](./attachments/img57.png)

Go back to the Caido **Intercept** interface. We can see that the requests are in the queue waiting to be forwarded. From here, we can inspect the full HTTP request before it reaches the server. For example, we can view the request method, path, headers, cookies, and submitted parameters. If we want the request to continue to the server, we press **Forward**.

![image](./attachments/img58.png)

Forward the requests with IDs 1, 2, and 3. We can now see the corresponding responses in the response queue, waiting to be forwarded to the browser. By selecting a response, we can view its response body, modify it, and decide whether we want to forward or drop it.

![image](./attachments/img59.png)

Forward all the responses and return to DVWA. As we can observe, the page is still loading because the last request has not been forwarded yet.

![image](./attachments/img60.png)

![image](./attachments/img61.png)

Let's modify the last request. Change the request path from: `/vulnerabilities/fi/?page=include.php`, to: `/vulnerabilities/brute/`. This will make the server return the **Brute Force** page instead of the **File Inclusion** page. Then press **Forward**.

![image](./attachments/img62.png)

Indeed, in the response, we can see that the page title belongs to the **Brute Force** page. Then forward the response.

![image](./attachments/img63.png)

If we return to DVWA, we can observe that we are now on the **Brute Force** page.

![image](./attachments/img64.png)

Change the **Intercept** state back to **Forwarding** so that future traffic will not remain queued.

![image](./attachments/img65.png)

### HTTP History

The **HTTP History** interface contains the HTTP requests and responses that passed through Caido’s proxy. Caido automatically records this traffic in the background, allowing us to review and analyze it at any time.

![image](./attachments/img66.png)

Browse DVWA and interact with a few pages, such as **Brute Force**, **Command Injection**, and **SQL Injection**. Fill in the input fields and submit the forms.

- **Brute Force**

>[!NOTE]
>
>Because we modified the request path in the previous **Intercept** section, the browser may display the **Brute Force** page while the URL still points to the **File Inclusion** page. Press the **Brute Force** button again to load the page normally before submitting the form.

Use `test:test` as the username and password.

![image](./attachments/img67.png)

- **Command Injection**

Use the following IP address:

```text
8.8.8.8
```

![image](./attachments/img68.png)

- **SQL Injection**

Use the following payload:

```text
' OR 1=1 -- -
```

![image](./attachments/img69.png)

Return to Caido and open the **HTTP History** interface. We can now see the captured requests in a table format. Each row represents one HTTP request and includes useful information such as the request method, host, path, response status code, and response length.

![image](./attachments/img70.png)

Set the **DVWA** scope to display only the requests related to our target.

![image](./attachments/img71.png)

Next to the scope button, we can press **Export** and then **Export all** to export the captured requests in CSV or JSON format.

![image](./attachments/img72.png)

In the search bar, we can enter HTTPQL queries to filter the requests we want to analyze.

![image](./attachments/img73.png)

By pressing **Advanced**, a side panel opens. From there, we can filter requests based on specific conditions, such as status codes, or use the filter presets we created in the **Filters** interface.

![image](./attachments/img74.png)

![image](./attachments/img75.png)

Select the **DVWA Form Submission** filter we created in the previous section. 

![image](./attachments/img76.png)

After applying the filter, Caido displays only the requests that match our HTTPQL expression. We can now select a request and view the full HTTP request and the corresponding HTTP response in the lower panels.

![image](./attachments/img77.png)

This makes HTTP History easier to analyze because we can quickly separate important application requests from normal browsing traffic, static files, images, styling, or unrelated domains.

### WS History

The **WS History** interface contains the WebSocket traffic that passed through Caido’s proxy. WebSockets are different from normal HTTP requests. A normal HTTP request usually follows a request-response model, where the browser sends a request and the server returns a response. In contrast, WebSockets keep a connection open, allowing the client and server to exchange messages in real time.

![image](./attachments/img78.png)

This interface allows us to view WebSocket streams and inspect the messages exchanged between the client and the server. This can be useful when testing applications that use live chats, notifications, dashboards, games, or other real-time features.

### Match & Replace

The **Match & Replace** interface allows us to create rules that automatically modify HTTP requests or responses as they pass through Caido.

This is useful when we want to repeatedly apply the same modification without editing each request manually. For example, we can add a custom header to every request, replace a value in a request body, remove a response header, or modify specific response content.

![image](./attachments/img79.png)

We will create a rule that modifies the **User-Agent** header in requests passing through Caido.

Press **New Rule**, then press the three dots next to the rule and select **Rename**. Name the rule `User-Agent Modification`.

![image](./attachments/img80.png)

Configure the new rule with the following values:

- **Section**: `Request Header`
- **Action**: `Update Value`
- **Name**: `User-Agent`
- **Value Type**: `String`
- **Value**: `Caido-Match-Replace-Demo/1.0`
- **Condition**: `req.host.cont:"dvwa.com"`
- **Sources**: `Intercept`

Then press **Update** to save the changes.

![image](./attachments/img81.png)

Now press the rule checkbox to activate it.

![image](./attachments/img82.png)

We set the **Sources** field to **Intercept**, which means that the rule will be applied to traffic managed by the Intercept interface. Change the **Intercept** state back to **Queuing** and return to DVWA. Browse to any page and then observe the request captured on the Intercept interface. As we can see in the request headers, the **User-Agent** header now has the value we defined in the rule.

![image](./attachments/img83.png)

Therefore, the rule worked successfully. Drop the request, change the **Intercept** state back to **Forwarding**, and disable the active rule we created.

![image](./attachments/img84.png)

>[!NOTE]
>
>Because we dropped the request, the browser may display an error. If this happens, refresh the page after changing the **Intercept** state back to **Forwarding**.

## Testing Section

### Replay

The **Replay** interface allows us to resend HTTP requests manually. This is useful when we want to test the same request multiple times with different parameters, headers, cookies, or payloads without repeating the action from the browser.

![image](./attachments/img85.png)

For the Replay demonstration, open the **SQL Injection** page in DVWA.

![image](./attachments/img86.png)

Fill in the user ID field with a normal value such as `1` and submit the form.

![image](./attachments/img87.png)

After the form submission, we receive the following response:

![image](./attachments/img88.png)

With the help of the Replay interface, we will try to identify how many columns the SQL query returns.

From the **HTTP History** interface, find the request generated by the form submission. Right-click the request and send it to a Replay collection. The request path should look similar to this:

```text
/vulnerabilities/sqli/?id=1&Submit=Submit
```

![image](./attachments/img89.png)

![image](./attachments/img90.png)

Now open the **Replay** interface. We can see that the selected request has been added as a Replay session.

A **session** in Replay represents a saved request that we can modify and resend multiple times. Each session keeps its own request and response history, allowing us to compare how the application behaves when we change parameters, headers, or payloads.

![image](./attachments/img91.png)

Replay requests can be organized into collections. Collections are useful because they allow us to group related requests together, for example, requests related to SQL injection, command injection, or authentication testing.

We will rename our existing collection to `SQL Injection`. Click the three dots next to the collection name and press **Rename**.

![image](./attachments/img92.png)

![image](./attachments/img93.png)

Now select the SQL Injection request in Replay. Press **Send** without making any changes. Caido sends the request again and displays the server response. If we scroll down, we can see the same response as the one displayed in the browser. This confirms that the request works correctly inside Replay.

![image](./attachments/img94.png)

Let's modify the `id` parameter in the request path to identify the injection point. Change the value of `id` to the following SQL injection payload:

```sql
' OR 1=1 -- -
```

Encoded:

```sql
'%20OR%201%3D1%20--%20-
```

The `%20` value is the URL-encoded representation of the **space** character.

![image](./attachments/img95.png)

![image](./attachments/img96.png)

As we can see, the request returned all the database users. This means that the `id` parameter is injectable. Next, we will use the SQL `UNION` operator to identify the number of columns returned by the original query. Change the payload to:

```sql
' UNION SELECT NULL -- -
```

Encoded:

```sql
'%20UNION%20SELECT%20NULL%20--%20-
```

Then send the request again.

![image](./attachments/img97.png)

![image](./attachments/img98.png)

The error in the response indicates that the number of columns used in the `UNION SELECT` statement is incorrect. Add another `NULL` value and send the request again.

```sql
'%20UNION%20SELECT%20NULL,NULL%20--%20-
```

![image](./attachments/img99.png)

![image](./attachments/img100.png)

![image](./attachments/img101.png)

This time, we received a **200** status code, and if we scroll down, we can see that the response is accepted by the application. This means that we found the number of columns returned by the original `SELECT` query.

This demonstrates why Replay is useful during web application testing. Instead of submitting the form repeatedly from the browser, we can modify and resend the same request directly from Caido and compare the responses.

We can review the requests sent within the current Replay session by clicking the **History** button in the top bar.

![image](./attachments/img102.png)

>[!NOTE]
>
>Replay sends the request directly from Caido. The browser page does not need to be refreshed for each test.

### Automate

The **Automate** interface allows us to send the same request multiple times while automatically changing one or more values. This is useful when we want to test many payloads without manually editing and sending each request one by one.

![image](./attachments/img103.png)

For the **Automate** demonstration, we will use the **Brute Force** page in DVWA. Our goal is to find the valid username and password combination.

First, we have to upload the wordlists that will be used during the brute-force test. These wordlists are located in the following directory: `~/BnB/Caido/`.

We will use two files:

- `usernames.txt`
- `passwords.txt`

Go to the **Files** interface in Caido and upload both wordlists.

![image](./attachments/img28.png)

![image](./attachments/img104.png)

![image](./attachments/img105.png)

After uploading them, the files will be available for use inside Automate as hosted wordlists.

Now return to DVWA and open the **Brute Force** page. Submit a normal login attempt using the following credentials:

```text
test:1234
```

![image](./attachments/img106.png)

Return to Caido and open the **HTTP History** interface. Find the request generated by the Brute Force form. It should be one of the latest captured requests.

The request path should look similar to this:

```text
/vulnerabilities/brute/?username=test&password=test&Login=Login
```

![image](./attachments/img107.png)

Right-click the request and select **Send to Automate**.

![image](./attachments/img108.png)

Now open the **Automate** interface. The selected request has been added as an Automate session. Automate sessions allow us to define payload positions, configure payload lists, run the request multiple times, and review the results.

![image](./attachments/img109.png)

Rename the Automate session to make it easier to identify. Press the three dots next to the session name and rename it to:

```text
Brute Force
```

![image](./attachments/img110.png)

![image](./attachments/img111.png)

Next, we need to define which parts of the request Caido should replace automatically.

In the request path, highlight the username value:

```text
test
```

Then press **Add Placeholder**.

![image](./attachments/img112.png)

![image](./attachments/img113.png)

This tells Caido that the selected username value should be replaced with payloads during the Automate run.

Now highlight the password value:

```text
1234
```

Then press **Add Placeholder** again.

![image](./attachments/img114.png)

![image](./attachments/img115.png)

At this point, we have two placeholders:

- One placeholder for the username value
- One placeholder for the password value

Before configuring the payloads, we must first set the payload strategy to **Matrix**. This is required because using multiple wordlists is only possible when the strategy is set to Matrix.

![image](./attachments/img116.png)

The **Matrix** strategy tests all possible combinations between the username wordlist and the password wordlist. For example, Caido will try combinations such as:

```text
test:123456
test:admin
test:test
user:123456
user:admin
user:test
```

Now we can configure the payloads for each placeholder. To change between placeholders click on them.

For the username placeholder, configure the payload with the following values:

- **Type**: `Hosted File`
- **Selected file**: `usernames.txt`

![image](./attachments/img117.png)

For the password placeholder, configure the payload with the following values:

- **Type**: `Hosted File`
- **Selected file**: `passwords.txt`

![image](./attachments/img118.png)

Before starting the run, open the **Settings** tab and keep the request rate low. For example, use:

- **Delay between requests**: `100`
- **Workers**: `1`

![image](./attachments/img119.png)

Now press **Run** to start the Automate session.

![image](./attachments/img120.png)

When the run is complete, each row in the results table represents one request sent by Automate.

![image](./attachments/img121.png)

To identify the successful login attempt, we can compare the responses. We know that an incorrect login attempt returns the following message in the response:

```text
Username and/or password incorrect.
```

Therefore, we can write an HTTPQL query that excludes all responses containing this message.

Write the following query in the search bar and press **Enter**:

```text
resp.raw.ncont:"Username and/or password incorrect."
```

![image](./attachments/img122.png)

As we can see, only the request that does not contain the failed-login message remains. Open this request and inspect the parameters used.

The valid credentials are:

```text
admin:password
```

![image](./attachments/img123.png)

This demonstrates why Automate is useful during web application testing. Instead of manually changing the username and password values and sending the request each time, Caido can automatically test multiple payload combinations and display the results in a table.

> [!NOTE]
>
> If all attempts fail, make sure DVWA is using the expected default credentials, the DVWA security level is set to **Low**, and the captured request contains a valid session cookie. If needed, capture a new Brute Force request and send it to Automate again.

### Workflows

The **Workflows** interface allows us to automate actions inside Caido. A workflow is built by connecting multiple nodes together, where each node performs a specific action. Workflows can be used to inspect requests and responses, apply conditions, run JavaScript logic, execute scripts, change request colors, create findings, and automate repetitive testing tasks.

![image](./attachments/img124.png)

There are three main types of workflows in Caido:

- **Passive workflows**: Run automatically as traffic flows through Caido
- **Active workflows**: Triggered manually by the user
- **Convert workflows**: Used to transform selected data, such as encoding, decoding, hashing, or formatting values

Caido includes some default workflows. The exact number may differ depending on the Caido version.

![image](./attachments/img125.png)

To open a workflow we can either click the pencil icon in the **Actions** column or double-click the workflow.

![image](./attachments/img126.png)

We can also copy a workflow by clicking the **Copy** icon in the **Actions** column. Copy the existing passive workflow.

![image](./attachments/img127.png)

It will automatically open it in the workflow editor.

![image](./attachments/img128.png)

In the workflow editor, we can connect nodes together to define the order of execution. The workflow starts from an entry node and continues from one node to the next. If a condition is used, the workflow can follow a different path depending on whether the condition is true or false.

Exit the workflow editor by clicking the **Passive** button again.

![image](./attachments/img129.png)

By selecting the checkbox of a workflow, we can either download it or delete it by pressing the corresponding button. In our case we will delete the copied workflow.

![image](./attachments/img130.png)

If we are working with a large number of workflows we can search the desired one from the search bar.

![image](./attachments/img131.png)

In this section, we will create a **Passive workflow**.

A **Passive workflow** runs automatically while traffic passes through Caido. This means that we do not have to manually execute it. When a request or response matches the workflow conditions, Caido executes the workflow automatically.

For this demonstration, we will use the **Command Injection** page in DVWA. The goal is to create a workflow that detects successful command execution and saves the command output into a local file. Before starting the implementation, we will inspect a valid and invalid request/response of the **Command Injection** page.

In the DVWA Command Injection page, submit 2 different forms with the following values:

- Valid value: `8.8.8.8`
- Invalid value: `a`

![image](./attachments/img68.png)

![image](./attachments/img132.png)

Now open the HTTP History interface to view these requests.

First, inspect the request with the valid value. In the request, the value we sent is delivered through a POST request to the `/vulnerabilities/exec/` endpoint and is located in the request payload assigned to the `ip` variable.

![image](./attachments/img133.png)

In the response, if we scroll down, we will see that the command output is between the `<pre></pre>` HTML tags.

![image](./attachments/img134.png)

Now inspect the request with the invalid value. The request part hasn't changed, but if we scroll down to the response, we will observe that the `<pre></pre>` tags don't contain anything.

![image](./attachments/img135.png)

This is a very good foothold to start our reasoning on how we can achieve our goal. We understand that the commands output is located between the `<pre></pre>` tags, and if the input value is invalid, these tags are empty.

Return to **Workflows** interface and press the **New Workflow** button in the top-left corner while we are in the **Passive** tab to start creating our new workflow.

![image](./attachments/img136.png)

Then change the **Name** and **Description** fields as follows:

- **Name**: Command Injection
- **Description**: Saves successful command injection outputs to a local file

![image](./attachments/img137.png)

The main area in the middle is the workflow canvas. This is where we add and connect nodes. Each node represents one action in the workflow.

![image](./attachments/img138.png)

At the bottom, Caido provides a Request and Response testing area. This area is used to manually test the workflow while building it. In our example, we will not use these areas.

![image](./attachments/img139.png)

The workflow starts with the **On Intercept Request** node, which triggers when Caido observes an HTTP request. The **Passive End** node marks where the workflow finishes.

![image](./attachments/img140.png)

We will use **On Intercept Response** because the command output is returned in the HTTP response body. If we used **On Intercept Request**, we would only have access to the request and not to the server response.

Click the **On Intercept Request** node and select **Delete**.

![image](./attachments/img141.png)

Then press the **Add Node** button and add the **On Intercept Response**.

![image](./attachments/img142.png)

![image](./attachments/img143.png)

![image](./attachments/img144.png)

After the **On Intercept Response** node, we will add a **Matches HTTPQL** node to filter the target requests.

Press the **Add Button** button, scroll down, and add a **Matches HTTPQL** node.

![image](./attachments/img145.png)

We can now connect the **On Intercept Response** node with the **Matches HTTPQL** one by dragging a line from **On Intercept Response** to **Matches HTTPQL**.

![image](./attachments/img146.png)

Click on the **Matches HTTPQL** node to configure it. It will open a small panel. For a better view, press the arrows to expand the window.

![image](./attachments/img147.png)

![image](./attachments/img148.png)

If needed, the name and alias can be changed, but we will leave them as they are.

![image](./attachments/img149.png)

As we saw in the HTTP History, we want to keep only POST requests sent to the `/vulnerabilities/exec/` endpoint. Hence, our HTTPQL query will only filter these requests.

Fill in the **Query** field with the following query:

```httpql
req.method.eq:"POST" AND req.path.cont:"/vulnerabilities/exec/"
```

![image](./attachments/img150.png)

In the **Request** field, select the request from the `On Intercept Response` node.

```text
$on_intercept_response.request
```

In the **Response** field, select the response from the `On Intercept Response` node.

```text
$on_intercept_response.response
```

![image](./attachments/img151.png)

These values connect the data from the **On Intercept Response** node to the current node. The request value provides the HTTP request that was sent to the server, while the response value provides the HTTP response returned by the server. This allows the node to inspect both sides of the communication. Then close the window.

To test our filter we will add a **Set Color** node after the **Matches HTTPQL** node.

Press the **Add Button** button, scroll down and add a **Set Color** node.

![image](./attachments/img152.png)

Like before, connect the **Matches HTTPQL** node with the **Set Color** node. Drag a line from the above output arrow of **Matches HTTPQL** node which indicates to true, and connect it to **Set Color** input arrow. Then connect the **Set Color** node with the **Passive End** node and save the workflow.

![image](./attachments/img153.png)

In the **Set Color** node, set the color to `27F208` and the **Request** field to:

```text
$on_intercept_response.request
```

This color indicates that the request matched the Command Injection endpoint, and in the next steps, we will use it for the requests that have the output of the valid commands.

![image](./attachments/img154.png)

Then close the window and press **Save**.

![image](./attachments/img155.png)

Now we will test our workflow. Open the DVWA page, press the **Command Injection** button, and submit a valid and an invalid value in the form.

![image](./attachments/img68.png)

![image](./attachments/img132.png)

Open HTTP History and remove the filter we previously assigned from Advanced. 

![image](./attachments/img156.png)

Observe that the two POST requests are highlighted with the color we specified and the GET request is not. This means that the **Matches HTTPQL** node works correctly.

![image](./attachments/img157.png)

Return to our workflow. After the **Matches HTTPQL** node, add an **If/Else JavaScript** node.

![image](./attachments/img158.png)

This node will check whether the response contains command output. Like before, connect the **Matches HTTPQL** node with the **If/Else JavaScript** node. Drag a line from the above output arrow of the **Matches HTTPQL** node and connect it to the **If/Else JavaScript** input arrow. Then connect the above output arrow of the **If/Else JavaScript** node, which indicates true, with the **Set Color** node.

![image](./attachments/img159.png)

Press the **If/Else JavaScript** node and expand the window.

In the **Code** field, we can write JavaScript code to check if the wanted condition is fulfilled. In our case, we want to know if in the response we have any value between the `<pre></pre>` tags.

Use the following JavaScript code:

```javascript
export async function run({ request, response }, sdk) {
  if (!response) {
    return false;
  }

  const body = response.getBody().toText();

  const emptyOutput = body.includes("<pre></pre>");
  const hasOutputBlock = body.includes("<pre>") && body.includes("</pre>");

  if (emptyOutput) {
    return false;
  }

  return hasOutputBlock;
}
```

This code checks the response body. If the response contains `<pre></pre>`, then the command did not produce output, so the workflow follows the **false** branch. If the response contains a `<pre>` block with content inside it, then the workflow follows the **true** branch.

![image](./attachments/img160.png)

In the **Request** field, choose the reference icon and select:

```text
$on_intercept_response.request
```

In the **Response** field, choose the reference icon and select:

```text
$on_intercept_response.response
```

![image](./attachments/img161.png)

Close the window and save the workflow.

Our workflow looks like this so far:

![image](./attachments/img162.png)

Let's test it again. Repeat the same steps as in the previous test.

Open HTTP History and see that this time only the request with the valid input is highlighted.

![image](./attachments/img163.png)

Therefore, the JavaScript code we wrote in the **Code** field in the **If/Else JavaScript** node is correct.

We will now add a **Shell** node in the true branch.

![image](./attachments/img164.png)

Connect it with the output arrow of the **If/Else JavaScript** node of the true branch, and its output with the **Set Color** node.

![image](./attachments/img165.png)

This node will run the program that extracts the command and its output from the HTTP request and response. In the `~/BnB/Caido` directory resides the `extract_command_output.py` python script that does the job for us. It reads the request and response sent by Caido to the Shell node. Then, it extracts the value of the `ip` parameter from the request and the output inside the `<pre>` and `</pre>` tags in the response. The results are saved in the `~/BnB/Caido/workflow-output/command-output.txt` file. Hence, we can `cat` this file to see the command and the corresponding result.

Open the **Shell** node window. In the code field, add only the following command:

```bash
python3 "$HOME/BnB/Caido/extract_command_output.py"
```

This command runs the Python script. Caido passes the selected request and response to the script through standard input.

![image](./attachments/img166.png)

Set the **Request** field to:

```text
$on_intercept_response.request
```

Set the **Response** field to:

```text
$on_intercept_response.response
```

Set the shell to `bash` and close the window.

![image](./attachments/img167.png)

Next, we will add a **Set Color** node in the false branch to mark the requests without command results with a different color.

Add a new **Set Color** node and connect its input to the false branch of the **If/Else JavaScript** node and its output to the **Passive End** node.

![image](./attachments/img152.png)

Our workflow is the following:

![image](./attachments/img168.png)

In the **Set Color** node, set the color to `FF0000` and the **Request** field to:

```text
$on_intercept_response.request
```

![image](./attachments/img169.png)

Close the window and save the workflow.

Let's test it. Return to DVWA, open the **Command Injection** page, and submit the following values:

- `8.8.8.8; pwd`
- `; id; whoami`
- `aaaaaaaa`
- `; cat /etc/passwd`
- `a.a.a.a`

Return to HTTP History and observe that values 1, 2, and 4 are highlighted in green, which indicates that the response contained command output. The rest are highlighted in red, which indicates that the response did not contain command output.

![image](./attachments/img170.png)

Hence, we are expecting to see only the output of the valid values in the `command-output.txt` file.

In the terminal run:

```bash
cd ~/BnB/Caido/
cat ./workflow-output/command-output.txt
```

![image](./attachments/img171.png)

Indeed, the command results are saved in the file. Every time a new successful command is executed, the result will be appended to the same file.

This demonstrates how Caido workflows can automate repetitive analysis tasks and help us collect useful information from HTTP traffic without manually copying data from every response.

### Assistant

The **Assistant** interface provides access to Caido's security-focused AI model. It can help during assessments by explaining traffic, suggesting possible attack vectors, and assisting with security-related analysis.

![image](./attachments/img172.png)

>[!NOTE]
>
>The **Assistant** interface is only available to Caido Individual and Team tier subscriptions.

### Environment

The **Environment** interface allows us to create variables that can be reused inside Caido. These variables can store values such as usernames, tokens, cookies, target URLs, or payloads that we want to use in multiple requests. Global environment variables are available across all projects, making them especially useful for values that need to be reused in different testing contexts.

![image](./attachments/img173.png)

We will create an environment variable that stores a SQL injection payload and then use it inside **Replay** with the SQL Injection request.

In the **Environment** interface, select the **Global** environment.

![image](./attachments/img174.png)

Press **Add** to create a new variable and configure it with the following values:

- **Name**: `sqli_payload`
- **Value**: `%27%20OR%201%3D1%20--%20-`

![image](./attachments/img175.png)

![image](./attachments/img176.png)

This value is the URL-encoded version of the `' OR 1=1 -- -` SQL injection payload we saw earlier.

After creating the variable, press **Update** to store the changes.

![image](./attachments/img177.png)

Now go back to the **Replay** interface and open the SQL Injection request we used earlier.

In the request path, change the value of the `id` parameter to something shorter, such as `var`, highlight it, and add it as a placeholder.

![image](./attachments/img178.png)

Open the placeholder settings and set the placeholder type to **Environment Variable**. Then select the `sqli_payload` variable we created and press **Add**.

![image](./attachments/img179.png)

![image](./attachments/img180.png)

![image](./attachments/img181.png)

Close the placeholder settings and press **Send**. Caido will replace the selected value with the value stored in the environment variable before sending the request.

If we inspect the response, we can observe that the SQL injection payload was used successfully.

![image](./attachments/img182.png)

## Logging Section

### Search

The **Search** interface allows us to search through HTTP traffic captured or generated inside Caido. Its interface is similar to **HTTP History**, but it is useful when we want to quickly locate specific requests or responses and identify where they came from, such as proxied browser traffic, Replay, Automate, or other Caido features.

![image](./attachments/img183.png)

In general, **HTTP History** is mainly used to review proxied traffic, while **Search** is used to search across traffic and identify matching requests from different Caido sources.

### Findings

The **Findings** interface is used to review security findings identified during testing. A finding is not just a normal HTTP request, it is an entry that documents something interesting, suspicious, or potentially vulnerable.

Findings can contain information such as the finding title, description, related request, and the tool or workflow that created it. Findings can be generated manually through workflows or by tools/plugins that support Caido’s Findings system.

![image](./attachments/img184.png)

We will now add two more nodes to our workflow in order to create a finding. These nodes are the following:

- **Check Finding**: Checks whether a finding already exists. We use it to prevent duplicate findings
- **Create Finding**: Creates the findings

Open the workflow we created previously and add these nodes. Connect the **Check Finding** node after the **Shell** node. Then, connect the **true** branch of the **Check Finding** node to **Set Color**, and the **false** branch to **Create Finding**. Finally, connect the output of the **Create Finding** node to **Set Color**.

![image](./attachments/img185.png)

![image](./attachments/img186.png)

![image](./attachments/img187.png)

Open the **Check Finding** node window and set the **Dedupe Key** field to the following value:

```
command_injection
```

The **Dedupe Key** is the unique identifier Caido uses to check whether this finding already exists.

![image](./attachments/img188.png)

Now open the **Create Finding** node window. Set the following values in the fields:

- **Title**: Command Injection
- **Request**: `$on_intercept_response.request`
- **Reporter**: Command Injection Workflow

The **Description** field supports Markdown. Therefore, we can write a description such as the following:

```text
A Command Injection vulnerability was detected on the `/vulnerabilities/exec/` endpoint.

The response contained command output inside the `<pre>` block.

The extracted commands and results are saved in:

`~/BnB/Caido/workflow-output/command-output.txt`
```

In the **Dedupe Key** field, enter the same key used in the **Check Finding** node:

- **Dedupe Key**: command_injection

![image](./attachments/img189.png)

Save the changes and return to the **Command Injection** page.

![image](./attachments/img190.png)

On the **Command Injection** page, submit two forms with the following payloads:

- `;id`
- `;whoami`

![image](./attachments/img191.png)

![image](./attachments/img192.png)

As we can see, in addition to the previous functionality, we now also have a finding. We do not have two findings because, after the second form submission, the **Check Finding** node detected that the finding already existed and therefore skipped the creation step.

![image](./attachments/img193.png)

We now have the finding, along with its description and the requests that triggered it.

![image](./attachments/img194.png)

### Exports

The **Exports** interface is used to view and download files that were exported from Caido. It is mainly useful when we want to save HTTP traffic outside Caido, share it, analyze it later, or include it in a report.

![image](./attachments/img195.png)

Exports are not created directly from this interface. First, we have to export data from another interface, such as **HTTP History** or **Search**.

To create an export, open a traffic table, click the **Export** drop-down menu, and choose whether to export all rows or only the currently displayed rows. The exported data can be saved as either a `.json` or `.csv` file. The exported files will then appear in the **Exports** interface, where they can be downloaded. 

>[!NOTE]
>
>The **Export current rows** option is only available to Caido Individual and Team subscriptions. If this option is not available, use **Export all** instead.

In simple words, the **Exports** interface acts as the download area for the files generated from Caido’s traffic tables.

## Cleanup

Open a terminal and execute the following commands:

```bash
cd ~/BnB/Caido/DVWA
sudo docker compose down
```


[Back to Compromised Web Server Main Page](/Decks/CORE_v3.1/IC/Compromised_Web_Server.md)
