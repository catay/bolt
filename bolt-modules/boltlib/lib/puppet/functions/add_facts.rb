# frozen_string_literal: true

require 'bolt/error'

# Deep merges a hash of facts with the existing facts on a target.
#
# **NOTE:** Not available in apply block
Puppet::Functions.create_function(:add_facts) do
  # @param target A target.
  # @param facts A hash of fact names to values that may include structured facts.
  # @return The target's new facts.
  # @example Adding facts to a target
  #   add_facts($target, { 'os' => { 'family' => 'windows', 'name' => 'windows' } })
  dispatch :add_facts do
    param 'Target', :target
    param 'Hash', :facts
    return_type 'Hash[String, Data]'
  end

  def add_facts(target, facts)
    unless Puppet[:tasks]
      raise Puppet::ParseErrorWithIssue
        .from_issue_and_stack(Bolt::PAL::Issues::PLAN_OPERATION_NOT_SUPPORTED_WHEN_COMPILING, action: 'add_facts')
    end

    inventory = Puppet.lookup(:bolt_inventory)
    executor = Puppet.lookup(:bolt_executor)
    executor.report_function_call(self.class.name)

    inventory.add_facts(target, facts)
  end
end
