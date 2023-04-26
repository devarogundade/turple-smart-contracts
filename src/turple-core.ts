
import {
    OwnershipTransferStarted as OwnershipTransferStartedEvent,
    OwnershipTransferred as OwnershipTransferredEvent,
    AdCreated as AdCreatedEvent,
    AppCreated as AppCreatedEvent,
    ProposalApproved as ProposalApprovedEvent,
    ProposalDisApproved as ProposalDisApprovedEvent
} from "../generated/TurpleCore/TurpleCore"

import {
    OwnershipTransferStarted,
    OwnershipTransferred,
    AdCreated,
    AppCreated,
    ProposalApproved,
    ProposalDisApproved
} from "../generated/schema"


export function handleOwnershipTransferStarted(
    event: OwnershipTransferStartedEvent
): void {
    let entity = new OwnershipTransferStarted(
        event.transaction.hash.concatI32(event.logIndex.toI32())
    )
    entity.previousOwner = event.params.previousOwner
    entity.newOwner = event.params.newOwner

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}

export function handleOwnershipTransferred(
    event: OwnershipTransferredEvent
): void {
    let entity = new OwnershipTransferred(
        event.transaction.hash.concatI32(event.logIndex.toI32())
    )
    entity.previousOwner = event.params.previousOwner
    entity.newOwner = event.params.newOwner

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}

export function handleAdCreated(
    event: AdCreatedEvent
): void {
    let entity = AdCreated.load(
        event.params.adId.toString()
    )

    if (!entity) {
        entity = new AdCreated(
            event.params.adId.toString()
        )
        entity.adId = event.params.adId
        entity.createdOn = event.params.createdOn
        entity.advertiser = event.params.advertiser
    }

    entity.format = event.params.format
    entity.category = event.params.category
    entity.balance = event.params.balance
    entity.state = event.params.state
    entity.metadata = event.params.metadata

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}

export function handleAppCreated(
    event: AppCreatedEvent
): void {
    let entity = AppCreated.load(
        event.params.appId.toString()
    )

    if (!entity) {
        entity = new AppCreated(
            event.params.appId.toString()
        )
        entity.appId = event.params.appId
        entity.createdOn = event.params.createdOn
        entity.publisher = event.params.publisher
    }

    entity.format = event.params.format
    entity.category = event.params.category
    entity.claimedReward = event.params.claimedReward
    entity.metadata = event.params.metadata

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}

export function handleProposalApproved(
    event: ProposalApprovedEvent
): void {
    let entity = new ProposalApproved(
        event.transaction.hash.concatI32(event.logIndex.toI32())
    )

    entity.adId = event.params.adId
    entity.validator = event.params.validator

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}

export function handleProposalDisApproved(
    event: ProposalDisApprovedEvent
): void {
    let entity = new ProposalDisApproved(
        event.transaction.hash.concatI32(event.logIndex.toI32())
    )

    entity.adId = event.params.adId
    entity.validator = event.params.validator

    entity.blockNumber = event.block.number
    entity.blockTimestamp = event.block.timestamp
    entity.transactionHash = event.transaction.hash

    entity.save()
}