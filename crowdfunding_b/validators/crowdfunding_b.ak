use aiken/crypto.{VerificationKeyHash}
use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}
use crowdfunding
use crowdfunding/types.{CampaignAction, CampaignDatum}

validator campaign(
  platform: VerificationKeyHash,
  creator: VerificationKeyHash,
  nonce: OutputReference,
) {
  mint(
    /// Create a new redeemer type to support multiple actions,
    /// eg:
    /// - `InitCampaign`(`CampaignDatum`)
    /// - `SupportCampaign`
    /// - `FinishCampaign` (to burn support tokens and mint prize/reward tokens)
    redeemer campaign_datum: CampaignDatum,
    policy_id self_script: PolicyId,
    tx: Transaction,
  ) {
    crowdfunding.validate_mint_campaign(
      platform,
      creator,
      nonce,
      campaign_datum,
      self_script,
      tx,
    )
  }

  spend(
    datum: Option<Data>,
    redeemer: CampaignAction,
    o_ref: OutputReference,
    tx: Transaction,
  ) {
    crowdfunding.validate_spend_campaign(
      platform,
      creator,
      nonce,
      datum,
      redeemer,
      o_ref,
      tx,
    )
  }

  else(_) {
    fail
  }
}
