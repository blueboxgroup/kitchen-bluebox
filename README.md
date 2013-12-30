# <a name="title"></a> Kitchen::Bluebox: A Test Kitchen Driver for Blue Box Blocks

[![Gem Version](https://badge.fury.io/rb/blueboxgroup%2Fkitchen-bluebox.png)](http://badge.fury.io/rb/blueboxgroup%2Fkitchen-bluebox)
[![Build Status](https://travis-ci.org/blueboxgroup/kitchen-bluebox.png?branch=master)](https://travis-ci.org/blueboxgroup/kitchen-bluebox)
[![Code Climate](https://codeclimate.com/github/blueboxgroup/kitchen-bluebox.png)](https://codeclimate.com/github/blueboxgroup/kitchen-bluebox)

A Test Kitchen Driver for Blue Box Blocks.

This driver uses the [fog gem][fog_gem] to provision and destroy blocks
instances. Use Blue Box's cloud for your infrastructure testing!

## <a name="requirements"></a> Requirements

There are **no** external system requirements for this driver. However you
will need access to a [Blue Box][bbg_site] account.

## <a name="installation"></a> Installation and Setup

Please read the [Driver usage][driver_usage] page for more details.

## <a name="config"></a> Configuration

### <a name="config-bluebox-customer-id"></a> bluebox\_customer\_id

**Required** The Blue Blue [customer id][blocks_docs] to use.

The default is unset, or `nil`.

### <a name="config-bluebox-api-key"></a> bluebox\_api\_key

**Required** The Blue Blue [api key][blocks_docs] to use.

The default is unset, or `nil`.

### <a name="config-flavor-id"></a> flavor\_id

The blocks [product type][blocks_docs] (also known as size) to use.

The default is `"94fd37a7-2606-47f7-84d5-9000deda52ae"`.

### <a name="config-image-id"></a> image\_id

The blocks [template id][blocks_docs] to use.

The default is `"573b8e80-823f-4100-bc2c-51b7c60f633c"`.

### <a name="config-location-id"></a> location\_id

The blocks [location][blocks_docs] to use.

The default is `"37c2bd9a-3e81-46c9-b6e2-db44a25cc675"`.

### <a name="config-port"></a> port

The SSH port number to be used when communicating with the instance.

The default is `22`.

### <a name="config-ssh-key"></a> ssh\_key

Path to the private SSH key used to connect to the instance.

The default is unset, or `nil`.

### <a name="config-sudo"></a> sudo

Whether or not to prefix remote system commands such as installing and
running Chef with `sudo`.

The default is `true`.

### <a name="config-username"></a> username

The SSH username that will be used to communicate with the instance.

The default is `"kitchen"`.

## <a name="example"></a> Example

The following could be used in a `.kitchen.yml` or in a `.kitchen.local.yml`
to override default configuration.

```yaml
---
driver_plugin: bluebox
driver_config:
  bluebox_customer_id: 123...
  bluebox_api_key: abc...
  location_id: def789...
  ssh_public_key: /path/to/id_dsa.pub
  ssh_key: /path/to/id_dsa
  require_chef_omnibus: true

platforms:
- name: ubuntu-12.04
  driver_config:
    image_id: b137c423-bade-4b01-9d13-271eea552563
- name: scientific-6.3
  driver_config:
    image_id: caaaca6b-fbe0-4e27-af2b-d100e46767bd

suites:
# ...
```

Both `.kitchen.yml` and `.kitchen.local.yml` files are pre-processed through
ERB which can help to factor out secrets and credentials. For example:

```yaml
---
driver_plugin: bluebox
driver_config:
  bluebox_customer_id: <%= ENV['BLUEBOX_CUSTOMER_ID'] %>
  bluebox_api_key: <%= ENV['BLUEBOX_API_KEY'] %>
  ssh_public_key: <%= File.expand_path('~/.ssh/id_dsa.pub') %>
  ssh_key: <%= File.expand_path('~/.ssh/id_dsa') %>
  require_chef_omnibus: true

platforms:
- name: ubuntu-12.04
  driver_config:
    image_id: b137c423-bade-4b01-9d13-271eea552563
- name: scientific-6.3
  driver_config:
    image_id: caaaca6b-fbe0-4e27-af2b-d100e46767bd

suites:
# ...
```

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## <a name="authors"></a> Authors

Created and maintained by [Fletcher Nichol][author] (<fnichol@nichol.ca>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/fnichol
[issues]:           https://github.com/blueboxgroup/kitchen-bluebox/issues
[license]:          https://github.com/blueboxgroup/kitchen-bluebox/blob/master/LICENSE
[repo]:             https://github.com/blueboxgroup/kitchen-bluebox
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.opscode.com/chef/install/

[bbg_site]:         https://bluebox.net/
[blocks_docs]:      https://boxpanel.bluebox.net/public/the_vault/index.php/Blocks_API
[fog_gem]:          http://fog.io/
