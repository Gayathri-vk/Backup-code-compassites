<div class="panel panel-default">
	<div class="panel-body">
	@include('flash::message')
		<div class="panel-heading no-bg panel-settings">
			<h3 class="panel-title">
			Create Role
			</h3>
		</div>
		<form method="POST" onsubmit="return validateRoleForm()" action="{{ url('admin/role/create') }}" class="socialite-form">
			{{ csrf_field() }}
			<div class="row">
				 
				<div class="col-md-12">
					<fieldset class="form-group required {{ $errors->has('rolename') ? ' has-error' : '' }}">
						{{ Form::label('rolename', 'Rolename', ['class' => 'control-label']) }}
						<input type="text" class="form-control content-form" placeholder="" name="rolename" value="">
						<small class="text-muted"></small>
						@if ($errors->has('rolename'))
						<span class="help-block">
							{{ $errors->first('rolename') }}
						</span>
						@endif
					</fieldset>
				</div>	

					<div class="form-group">
		<label class="col-sm-2 control-label">Permissions</label>
		<div class="col-sm-10">
			 <ul class="col-md-10 col-xs-10">
                @foreach($permissions as $permission)
                    <li class="clearfix checkbox">
                        <label class="color-blue">
                        <input type="checkbox" name="permissions[]"
                            value="{{$permission->id}}"/>
                            {{$permission->name}}
                        </label>
                    </li>
                @endforeach
                </ul>
        </div>
		</div>			
			</div>

			<div class="pull-right">
				<button type="submit" class="btn btn-primary btn-sm">{{ trans('common.save_changes') }}</button>
			</div>
		</form>
		
	</div>
</div>

<script>

function validateRoleForm()
{
	var type = $('input[name="permissions[]"]:checked').length;

      if(type == 0) {
        alert("Please check atleas one  Permission");
        return false;
      }
       return true;
}
</script>